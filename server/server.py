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

def get_all_ips():
    ips = []
    try:
        hostname = socket.gethostname()
        for ip in socket.gethostbyname_ex(hostname)[2]:
            if not ip.startswith('127.'):
                ips.append(ip)
    except Exception:
        pass
    if not ips:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(('8.8.8.8', 80))
            ips.append(s.getsockname()[0])
            s.close()
        except Exception:
            ips.append('127.0.0.1')
    return ips

def launch_windows_app(command):
    print(f"\n[LAUNCHING] Running command: {command}")
    try:
        if sys.platform == 'win32':
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
                "ips": get_all_ips(),
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
    all_ips = get_all_ips()
    server_address = ('0.0.0.0', PORT)
    
    print("\n" + "="*65)
    print("      WinDock Bridge Server - Windows Application Launcher")
    print("="*65)
    print(f"  PC Hostname : {socket.gethostname()}")
    print(f"  Port        : {PORT}")
    print("\n  Available Connection Addresses:")
    for ip in all_ips:
        if ip.startswith("172.20.10."):
            print(f"   * [USB CABLE]   : http://{ip}:{PORT}  <-- USE THIS FOR CABLE!")
        else:
            print(f"   * [Wi-Fi/LAN]   : http://{ip}:{PORT}")
    print("="*65)
    print("\n[🔌 HOW TO CONNECT VIA CABLE (ZERO WI-FI REQUIRED)]:")
    print("  1. Plug your iPhone into this Windows PC with the USB Cable.")
    print("  2. On iPhone: Go to Settings -> Personal Hotspot -> Turn ON 'Allow Others to Join'.")
    print("     (If prompted, select 'USB Only'. Wi-Fi can remain completely OFF!)")
    print("  3. On iPhone: Open Safari and type: http://172.20.10.2:5050 (or the USB IP above).")
    print("  4. Tap Share -> 'Add to Home Screen' for instant full-screen app dock over cable!")
    print("\n[+] Server listening for launch requests... Press Ctrl+C to stop.\n")

    httpd = ThreadedHTTPServer(server_address, WinDockHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[!] Shutting down WinDock Server.")
        httpd.server_close()

if __name__ == '__main__':
    main()
