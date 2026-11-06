import http.server
import socketserver
import json
import os
import sys
import socket
import subprocess
import threading
import time
from urllib.parse import urlparse, parse_qs

PORT = 5050
WEB_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'web')

# Default 8 Windows Apps to launch
DEFAULT_APPS = [
    {
        "id": "chrome",
        "name": "Chrome",
        "icon": "chrome",
        "command": "start chrome",
        "color": "#4285F4",
        "category": "Browser"
    },
    {
        "id": "vscode",
        "name": "VS Code",
        "icon": "vscode",
        "command": "code",
        "color": "#007ACC",
        "category": "Dev"
    },
    {
        "id": "discord",
        "name": "Discord",
        "icon": "discord",
        "command": "start discord:",
        "color": "#5865F2",
        "category": "Social"
    },
    {
        "id": "spotify",
        "name": "Spotify",
        "icon": "spotify",
        "command": "start spotify:",
        "color": "#1DB954",
        "category": "Music"
    },
    {
        "id": "steam",
        "name": "Steam",
        "icon": "steam",
        "command": "start steam:",
        "color": "#171A21",
        "category": "Gaming"
    },
    {
        "id": "terminal",
        "name": "Terminal",
        "icon": "terminal",
        "command": "wt || powershell",
        "color": "#1F2430",
        "category": "Tools"
    },
    {
        "id": "explorer",
        "name": "Explorer",
        "icon": "explorer",
        "command": "explorer",
        "color": "#F3B300",
        "category": "System"
    },
    {
        "id": "taskmgr",
        "name": "Task Manager",
        "icon": "taskmgr",
        "command": "taskmgr",
        "color": "#00A4EF",
        "category": "System"
    }
]

CONFIG_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'apps_config.json')

def load_apps():
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception:
            pass
    return DEFAULT_APPS

def save_apps(apps_list):
    try:
        with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
            json.dump(apps_list, f, indent=2)
        return True
    except Exception as e:
        print(f"[Error saving config]: {e}")
        return False

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('8.8.8.8', 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return '127.0.0.1'

def launch_windows_app(command):
    print(f"\n[LAUNCHING] Running command: {command}")
    try:
        if sys.platform == 'win32':
            # Run via Windows shell in background without blocking
            subprocess.Popen(f'cmd.exe /c "{command}"', shell=True)
            return True, f"Successfully executed: {command}"
        else:
            subprocess.Popen(command, shell=True)
            return True, f"Executed command: {command}"
    except Exception as e:
        print(f"[Launch Error]: {e}")
        return False, str(e)

class WinDockHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def end_headers(self):
        # Enable CORS for iOS app & external clients
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        parsed = urlparse(self.path)
        
        if parsed.path == '/api/status':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            status_data = {
                "status": "online",
                "hostname": socket.gethostname(),
                "ip": get_local_ip(),
                "port": PORT,
                "os": sys.platform,
                "time": time.strftime("%Y-%m-%d %H:%M:%S")
            }
            self.wfile.write(json.dumps(status_data).encode('utf-8'))
            return
            
        elif parsed.path == '/api/apps':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            apps = load_apps()
            self.wfile.write(json.dumps({"apps": apps}).encode('utf-8'))
            return
            
        # Default static file serving from web directory
        return super().do_GET()

    def do_POST(self):
        parsed = urlparse(self.path)
        
        content_length = int(self.headers.get('Content-Length', 0))
        post_body = self.rfile.read(content_length) if content_length > 0 else b'{}'
        
        try:
            body = json.loads(post_body.decode('utf-8'))
        except Exception:
            body = {}

        if parsed.path == '/api/launch':
            cmd = body.get('command')
            app_id = body.get('id')
            
            if not cmd and app_id:
                # Find by app ID
                apps = load_apps()
                for app in apps:
                    if app.get('id') == app_id:
                        cmd = app.get('command')
                        break
                        
            if cmd:
                success, msg = launch_windows_app(cmd)
                self.send_response(200 if success else 500)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"success": success, "message": msg}).encode('utf-8'))
            else:
                self.send_response(400)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"success": False, "error": "No command provided"}).encode('utf-8'))
            return

        elif parsed.path == '/api/apps':
            new_apps = body.get('apps')
            if isinstance(new_apps, list):
                save_apps(new_apps)
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"success": True, "apps": new_apps}).encode('utf-8'))
            else:
                self.send_response(400)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"success": False, "error": "Invalid format"}).encode('utf-8'))
            return

        self.send_response(404)
        self.end_headers()

class ThreadedHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    daemon_threads = True

def main():
    local_ip = get_local_ip()
    server_address = ('0.0.0.0', PORT)
    
    print("\n" + "="*60)
    print("      WinDock Bridge Server - Windows Application Launcher")
    print("="*60)
    print(f"  PC Hostname  : {socket.gethostname()}")
    print(f"  Local LAN IP : {local_ip}")
    print(f"  Port         : {PORT}")
    print(f"  Server URL   : http://{local_ip}:{PORT}")
    print("="*60)
    print("\n[+] Instructions for iPhone:")
    print(f"  1. Ensure iPhone is on the SAME Wi-Fi network as this PC.")
    print(f"  2. In the WinDock iOS App, enter Server IP: {local_ip} (Port: {PORT}).")
    print(f"  3. Or open Safari on iPhone and browse to: http://{local_ip}:{PORT}")
    print("     and tap 'Share -> Add to Home Screen' for instant full-screen app!")
    print("\n[+] Server is listening for incoming launch requests... Press Ctrl+C to stop.\n")

    httpd = ThreadedHTTPServer(server_address, WinDockHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[!] Shutting down WinDock Server.")
        httpd.server_close()

if __name__ == '__main__':
    main()
