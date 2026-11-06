// WinDock Web Client

// Authentic High-Fidelity SVG Icons for the 8 Apps
const APP_ICONS = {
  chrome: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <circle cx="50" cy="50" r="48" fill="#F8F9FA"/>
      <path d="M50 15 A35 35 0 0 1 80.3 32.5 L65 59 A17 17 0 0 0 50 33 Z" fill="#EA4335"/>
      <path d="M80.3 32.5 A35 35 0 0 1 50 85 L50 55 A17 17 0 0 0 65 59 Z" fill="#FBBC05"/>
      <path d="M50 85 A35 35 0 0 1 19.7 32.5 L45 47 A17 17 0 0 0 50 67 L50 85 Z" fill="#34A853"/>
      <circle cx="50" cy="50" r="20" fill="#FFFFFF"/>
      <circle cx="50" cy="50" r="15" fill="#4285F4"/>
    </svg>
  `,
  browser: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#0078D7"/>
      <circle cx="50" cy="50" r="28" fill="none" stroke="#FFFFFF" stroke-width="4"/>
      <ellipse cx="50" cy="50" rx="14" ry="28" fill="none" stroke="#FFFFFF" stroke-width="3"/>
      <line x1="22" y1="50" x2="78" y2="50" stroke="#FFFFFF" stroke-width="3"/>
    </svg>
  `,
  vscode: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <defs>
        <linearGradient id="vsGrad1" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#0065A9"/>
          <stop offset="100%" stop-color="#007ACC"/>
        </linearGradient>
        <linearGradient id="vsGrad2" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#1F9CF0"/>
          <stop offset="100%" stop-color="#0065A9"/>
        </linearGradient>
      </defs>
      <rect width="100" height="100" rx="22" fill="#181818"/>
      <path d="M72 15 L32 46 L20 37 L14 41 L26 50 L14 59 L20 63 L32 54 L72 85 A4 4 0 0 0 78 82 L78 18 A4 4 0 0 0 72 15 Z" fill="url(#vsGrad1)"/>
      <path d="M72 15 L48 40 L48 60 L72 85 Z" fill="url(#vsGrad2)" opacity="0.8"/>
      <path d="M78 18 L60 50 L78 82 Z" fill="#0065A9"/>
    </svg>
  `,
  discord: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#5865F2"/>
      <path d="M73 29 C67.5 26.5 61.6 24.7 55.4 23.8 C54.6 25.2 53.7 27.2 53 28.7 C46.4 27.7 39.8 27.7 33.3 28.7 C32.6 27.2 31.6 25.2 30.8 23.8 C24.6 24.7 18.7 26.5 13.2 29 C2.3 45.4 -0.6 61.4 0.8 77.2 C8 82.5 15 85.7 21.9 87.9 C23.6 85.5 25.2 83 26.5 80.2 C24 79.3 21.7 78.1 19.4 76.6 C20 76.2 20.6 75.7 21.1 75.3 C35.2 81.8 51.1 81.8 65 75.3 C65.6 75.8 66.2 76.2 66.8 76.6 C64.6 78.1 62.2 79.3 59.8 80.2 C61.1 83 62.6 85.5 64.3 87.9 C71.2 85.7 78.2 82.5 85.4 77.2 C87.1 59.1 82.7 43.3 73 29 Z M28.7 65.2 C24.5 65.2 21 61.3 21 56.6 C21 51.9 24.4 48 28.7 48 C33 48 36.5 51.9 36.4 56.6 C36.4 61.3 33 65.2 28.7 65.2 Z M57.5 65.2 C53.3 65.2 49.8 61.3 49.8 56.6 C49.8 51.9 53.2 48 57.5 48 C61.8 48 65.3 51.9 65.2 56.6 C65.2 61.3 61.8 65.2 57.5 65.2 Z" fill="#FFFFFF"/>
    </svg>
  `,
  spotify: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#1DB954"/>
      <path d="M68.7 67.5 C67.8 69 66 69.4 64.5 68.5 C53.3 61.6 39.4 60.1 23.1 63.8 C21.4 64.2 19.8 63.1 19.4 61.4 C19 59.7 20.1 58.1 21.8 57.7 C39.6 53.6 55 55.4 67.6 63.2 C69.1 64.1 69.6 66 68.7 67.5 Z M74.7 54.8 C73.6 56.6 71.3 57.1 69.5 56 C56.8 48.2 37.5 45.9 22.5 50.5 C20.4 51.1 18.3 49.9 17.6 47.9 C17 45.8 18.2 43.7 20.3 43 C37.4 37.8 58.7 40.3 73.2 49.3 C75 50.3 75.6 52.9 74.7 54.8 Z M75.4 41.7 C60.1 32.6 34.9 31.8 20.3 36.2 C18 36.9 15.5 35.6 14.8 33.3 C14.1 31 15.4 28.5 17.7 27.8 C34.6 22.7 62.5 23.6 80.1 34.1 C82.2 35.3 82.9 38.1 81.7 40.2 C80.5 42.2 77.5 42.9 75.4 41.7 Z" fill="#FFFFFF"/>
    </svg>
  `,
  steam: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <defs>
        <radialGradient id="steamBg" cx="30%" cy="30%" r="70%">
          <stop offset="0%" stop-color="#1B2838"/>
          <stop offset="100%" stop-color="#111822"/>
        </radialGradient>
      </defs>
      <rect width="100" height="100" rx="22" fill="url(#steamBg)"/>
      <path d="M50 18 A32 32 0 0 0 18 50 A32 32 0 0 0 31.5 76.5 L40.6 63.2 A13 13 0 0 1 45.5 47 L65 37.5 A18 18 0 1 1 76 65 L57.8 74 A14 14 0 0 1 38.4 78.5 A32 32 0 1 0 50 18 Z" fill="#FFFFFF"/>
      <circle cx="68" cy="46" r="10" fill="#1B2838"/>
      <circle cx="48" cy="62" r="6" fill="#1B2838"/>
    </svg>
  `,
  terminal: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#1E1E1E"/>
      <circle cx="22" cy="22" r="4" fill="#FF5F56"/>
      <circle cx="34" cy="22" r="4" fill="#FFBD2E"/>
      <circle cx="46" cy="22" r="4" fill="#27C93F"/>
      <path d="M24 45 L42 56 L24 67" fill="none" stroke="#4AF626" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>
      <line x1="48" y1="67" x2="68" y2="67" stroke="#4AF626" stroke-width="6" stroke-linecap="round"/>
    </svg>
  `,
  explorer: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <defs>
        <linearGradient id="folderBase" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#FFD659"/>
          <stop offset="100%" stop-color="#F2A900"/>
        </linearGradient>
      </defs>
      <rect width="100" height="100" rx="22" fill="#F4F5F7"/>
      <path d="M20 28 A4 4 0 0 1 24 24 L44 24 A4 4 0 0 1 47 26 L53 32 L76 32 A4 4 0 0 1 80 36 L80 44 L20 44 Z" fill="#0078D4"/>
      <path d="M16 40 L84 40 L80 76 A6 6 0 0 1 74 82 L26 82 A6 6 0 0 1 20 76 Z" fill="url(#folderBase)"/>
    </svg>
  `,
  taskmgr: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <defs>
        <linearGradient id="pulseBg" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#0067B8"/>
          <stop offset="100%" stop-color="#002050"/>
        </linearGradient>
      </defs>
      <rect width="100" height="100" rx="22" fill="url(#pulseBg)"/>
      <line x1="18" y1="35" x2="82" y2="35" stroke="rgba(255,255,255,0.15)" stroke-width="1.5" stroke-dasharray="3,3"/>
      <line x1="18" y1="52" x2="82" y2="52" stroke="rgba(255,255,255,0.15)" stroke-width="1.5" stroke-dasharray="3,3"/>
      <line x1="18" y1="69" x2="82" y2="69" stroke="rgba(255,255,255,0.15)" stroke-width="1.5" stroke-dasharray="3,3"/>
      <path d="M16 52 L34 52 L40 32 L47 72 L54 44 L60 52 L84 52" fill="none" stroke="#00FF88" stroke-width="4.5" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  `,
  calc: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#FF9500"/>
      <path d="M30 36 H70 M30 50 H70 M50 24 V62 M30 76 H70" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round"/>
    </svg>
  `,
  notepad: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#0078D4"/>
      <rect x="25" y="22" width="50" height="56" rx="4" fill="#FFFFFF"/>
      <line x1="33" y1="34" x2="67" y2="34" stroke="#0078D4" stroke-width="3"/>
      <line x1="33" y1="44" x2="67" y2="44" stroke="#0078D4" stroke-width="3"/>
      <line x1="33" y1="54" x2="55" y2="54" stroke="#0078D4" stroke-width="3"/>
    </svg>
  `,
  gear: `
    <svg viewBox="0 0 100 100" width="100%" height="100%">
      <rect width="100" height="100" rx="22" fill="#4A4A4A"/>
      <circle cx="50" cy="50" r="16" fill="none" stroke="#FFFFFF" stroke-width="8"/>
      <circle cx="50" cy="50" r="28" fill="none" stroke="#FFFFFF" stroke-width="6" stroke-dasharray="8 6"/>
    </svg>
  `
};

// Full Catalog of Selectable Windows Apps
const APP_CATALOG = [
  { id: "chrome", name: "Google Chrome", icon: "chrome", command: "start chrome" },
  { id: "edge", name: "Microsoft Edge", icon: "browser", command: "start msedge" },
  { id: "vscode", name: "VS Code", icon: "vscode", command: "code" },
  { id: "discord", name: "Discord", icon: "discord", command: "start discord:" },
  { id: "spotify", name: "Spotify", icon: "spotify", command: "start spotify:" },
  { id: "steam", name: "Steam", icon: "steam", command: "start steam:" },
  { id: "terminal", name: "Terminal", icon: "terminal", command: "wt" },
  { id: "powershell", name: "PowerShell", icon: "terminal", command: "powershell" },
  { id: "explorer", name: "File Explorer", icon: "explorer", command: "explorer" },
  { id: "taskmgr", name: "Task Manager", icon: "taskmgr", command: "taskmgr" },
  { id: "calc", name: "Calculator", icon: "calc", command: "calc" },
  { id: "notepad", name: "Notepad", icon: "notepad", command: "notepad" },
  { id: "settings", name: "Settings", icon: "gear", command: "start ms-settings:" }
];

let currentMode = '8apps';
let appsList = [];
let serverHost = localStorage.getItem('windock_server') || window.location.host || '127.0.0.1:5050';
let isServerOnline = false;
let editingSlot = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('serverIpInput').value = serverHost;
  initClock();
  loadSavedApps();
  checkServerHealth();
  setInterval(checkServerHealth, 5000);
});

function loadSavedApps() {
  const saved = localStorage.getItem('windock_apps_v2');
  if (saved) {
    try {
      appsList = JSON.parse(saved);
    } catch(e) {
      fallbackDefaultApps();
    }
  } else {
    fallbackDefaultApps();
  }
  renderApps();
}

function fallbackDefaultApps() {
  appsList = [
    { id: 'chrome', name: 'Chrome', icon: 'chrome', command: 'start chrome' },
    { id: 'vscode', name: 'VS Code', icon: 'vscode', command: 'code' },
    { id: 'discord', name: 'Discord', icon: 'discord', command: 'start discord:' },
    { id: 'spotify', name: 'Spotify', icon: 'spotify', command: 'start spotify:' },
    { id: 'steam', name: 'Steam', icon: 'steam', command: 'start steam:' },
    { id: 'terminal', name: 'Terminal', icon: 'terminal', command: 'wt' },
    { id: 'explorer', name: 'Explorer', icon: 'explorer', command: 'explorer' },
    { id: 'taskmgr', name: 'Task Manager', icon: 'taskmgr', command: 'taskmgr' }
  ];
}

function saveAppsLocally() {
  localStorage.setItem('windock_apps_v2', JSON.stringify(appsList));
}

// Mode Switching (8 Apps vs 4 Apps + Clock)
function switchMode(mode) {
  currentMode = mode;
  const btn8 = document.getElementById('mode8Btn');
  const btn4Clock = document.getElementById('mode4ClockBtn');
  const layout8 = document.getElementById('layout8Apps');
  const layout4Clock = document.getElementById('layout4Clock');

  if (mode === '8apps') {
    btn8.classList.add('active');
    btn4Clock.classList.remove('active');
    layout8.style.display = 'block';
    layout4Clock.style.display = 'none';
  } else {
    btn8.classList.remove('active');
    btn4Clock.classList.add('active');
    layout8.style.display = 'none';
    layout4Clock.style.display = 'block';
  }
  renderApps();
}

function setServerStatus(online, hostname = 'Windows Desktop') {
  isServerOnline = online;
  const dot = document.getElementById('statusDot');
  const text = document.getElementById('statusText');
  const pcBadge = document.getElementById('pcName');

  if (online) {
    dot.className = 'status-dot online';
    text.innerText = 'Connected to PC';
    pcBadge.innerText = hostname;
  } else {
    dot.className = 'status-dot offline';
    text.innerText = 'Connecting...';
  }
}

async function checkServerHealth() {
  const protocol = window.location.protocol.startsWith('http') ? window.location.protocol : 'http:';
  try {
    const res = await fetch(`${protocol}//${serverHost}/api/status`, { method: 'GET' });
    if (res.ok) {
      const data = await res.json();
      setServerStatus(true, data.hostname || 'Windows PC');
    } else {
      setServerStatus(false);
    }
  } catch (e) {
    setServerStatus(false);
  }
}

// Render Apps into DOM with tap to launch and long-press to edit
function renderApps() {
  const grid8 = document.getElementById('appsGrid8');
  const left4 = document.getElementById('leftApps4');

  grid8.innerHTML = '';
  left4.innerHTML = '';

  appsList.forEach((app, idx) => {
    const iconSvg = APP_ICONS[app.icon] || APP_ICONS.chrome;
    
    // Create App Item element
    const appEl = document.createElement('div');
    appEl.className = 'app-item';
    appEl.innerHTML = `
      <div class="app-icon" id="icon-${app.id}">
        ${iconSvg}
      </div>
      <span class="app-name">${app.name}</span>
    `;

    // Long press detection for editing
    let pressTimer;
    let isLongPress = false;

    const startPress = () => {
      isLongPress = false;
      pressTimer = setTimeout(() => {
        isLongPress = true;
        if (navigator.vibrate) navigator.vibrate([30, 50, 30]);
        openSlotChooser(idx);
      }, 550);
    };

    const cancelPress = () => {
      clearTimeout(pressTimer);
    };

    appEl.addEventListener('touchstart', startPress);
    appEl.addEventListener('touchend', (e) => {
      cancelPress();
      if (!isLongPress) launchApp(app);
    });
    appEl.addEventListener('mousedown', startPress);
    appEl.addEventListener('mouseup', () => {
      cancelPress();
      if (!isLongPress) launchApp(app);
    });
    appEl.addEventListener('mouseleave', cancelPress);

    // Append to 8-grid
    if (idx < 8) {
      grid8.appendChild(appEl.cloneNode(true));
      const child = grid8.lastChild;
      child.addEventListener('touchstart', startPress);
      child.addEventListener('touchend', (e) => {
        cancelPress();
        if (!isLongPress) launchApp(app);
      });
      child.addEventListener('mousedown', startPress);
      child.addEventListener('mouseup', () => {
        cancelPress();
        if (!isLongPress) launchApp(app);
      });
      child.addEventListener('mouseleave', cancelPress);
    }

    // Append first 4 to left dock
    if (idx < 4) {
      left4.appendChild(appEl);
    }
  });

  renderCustomizerList();
}

// Launch Application on Windows Server
async function launchApp(app) {
  if (navigator.vibrate) {
    navigator.vibrate(25);
  }

  showToast(`Launching ${app.name} on PC...`);

  const protocol = window.location.protocol.startsWith('http') ? window.location.protocol : 'http:';
  const url = `${protocol}//${serverHost}/api/launch`;

  try {
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: app.id, command: app.command, name: app.name })
    });
    const result = await res.json();
    if (result.success) {
      showToast(`✓ Opened ${app.name}`);
    } else {
      showToast(`⚠️ Failed: ${result.error || 'Server error'}`);
    }
  } catch (err) {
    showToast(`⚠️ PC unreachable at ${serverHost}`);
    setServerStatus(false);
  }
}

// Toast notification
let toastTimer = null;
function showToast(msg) {
  const toast = document.getElementById('toastPill');
  const msgEl = document.getElementById('toastMsg');
  msgEl.innerText = msg;
  toast.classList.add('show');

  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    toast.classList.remove('show');
  }, 2200);
}

// Live Apple-Style StandBy Clock
function initClock() {
  function updateTime() {
    const now = new Date();
    let hours = now.getHours();
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = now.getSeconds();
    const ampm = hours >= 12 ? 'PM' : 'AM';

    hours = hours % 12;
    hours = hours ? hours : 12;

    document.getElementById('clockHours').innerText = hours;
    document.getElementById('clockMinutes').innerText = minutes;
    document.getElementById('clockAmPm').innerText = ampm;

    const pct = ((seconds + 1) / 60) * 100;
    document.getElementById('secondsBar').style.width = `${pct}%`;

    const days = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    const dayStr = days[now.getDay()];
    const monthStr = months[now.getMonth()];
    const dateNum = now.getDate();

    document.getElementById('clockDate').innerText = `${dayStr}, ${monthStr} ${dateNum}`;
  }

  updateTime();
  setInterval(updateTime, 1000);
}

// Settings Modal
function openSettings() {
  document.getElementById('settingsModal').classList.add('show');
}

function closeSettings(e) {
  if (e && e.target !== document.getElementById('settingsModal') && !e.target.classList.contains('close-btn')) return;
  document.getElementById('settingsModal').classList.remove('show');
}

function saveServerAddress() {
  const val = document.getElementById('serverIpInput').value.trim();
  if (val) {
    serverHost = val;
    localStorage.setItem('windock_server', val);
    showToast(`Connecting to ${val}...`);
    checkServerHealth();
    document.getElementById('settingsModal').classList.remove('show');
  }
}

// Render Customizer Slot List
function renderCustomizerList() {
  const list = document.getElementById('customizerList');
  if (!list) return;
  list.innerHTML = '';

  appsList.forEach((app, idx) => {
    const row = document.createElement('div');
    row.className = 'customizer-row';
    row.style.cursor = 'pointer';
    row.innerHTML = `
      <div style="display: flex; align-items: center; gap: 8px;">
        <span style="background: ${idx < 4 ? '#0071E3' : '#8E8E93'}; color: white; padding: 2px 7px; border-radius: 999px; font-size: 11px;">Slot ${idx+1}</span>
        <strong>${app.name}</strong>
      </div>
      <button class="save-btn" style="padding: 4px 10px; font-size: 12px;" onclick="openSlotChooser(${idx})">Change</button>
    `;
    list.appendChild(row);
  });
}

// Slot Chooser Modal for picking from Catalog or Custom Command
function openSlotChooser(slotIndex) {
  editingSlot = slotIndex;
  closeSettings();

  let chooser = document.getElementById('slotChooserModal');
  if (!chooser) {
    chooser = document.createElement('div');
    chooser.id = 'slotChooserModal';
    chooser.className = 'modal-backdrop';
    chooser.onclick = closeSlotChooser;
    document.body.appendChild(chooser);
  }

  const current = appsList[slotIndex];

  let catalogHtml = APP_CATALOG.map(item => `
    <div class="customizer-row" style="cursor: pointer; margin-bottom: 6px;" onclick="selectCatalogApp(${slotIndex}, '${item.id}')">
      <div style="display: flex; align-items: center; gap: 10px;">
        <div style="width: 32px; height: 32px;">${APP_ICONS[item.icon] || APP_ICONS.chrome}</div>
        <div>
          <div style="font-weight: 600; font-size: 14px;">${item.name}</div>
          <div style="font-size: 11px; color: #86868B; font-family: monospace;">${item.command}</div>
        </div>
      </div>
      ${current && current.name === item.name ? '<span style="color: #0071E3; font-weight: bold;">✓ Active</span>' : ''}
    </div>
  `).join('');

  chooser.innerHTML = `
    <div class="modal-card apple-glass" onclick="event.stopPropagation()" style="max-height: 80vh; overflow-y: auto;">
      <div class="modal-header">
        <h3>Choose App for Slot ${slotIndex + 1}</h3>
        <button class="close-btn" onclick="closeSlotChooser()">&times;</button>
      </div>
      <div class="modal-body">
        <label class="form-label">Pick from Windows Apps Catalog</label>
        <div style="margin-bottom: 14px;">
          ${catalogHtml}
        </div>
        <hr class="modal-hr">
        <label class="form-label">Or Custom App Executable</label>
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <input type="text" id="customNameInput" class="apple-input" placeholder="App Name (e.g. Photoshop)">
          <input type="text" id="customCmdInput" class="apple-input" placeholder="Command (e.g. C:\\app.exe)">
          <button class="save-btn" onclick="saveCustomAppForSlot(${slotIndex})">Save Custom App</button>
        </div>
      </div>
    </div>
  `;

  chooser.classList.add('show');
}

function closeSlotChooser() {
  const chooser = document.getElementById('slotChooserModal');
  if (chooser) chooser.classList.remove('show');
}

function selectCatalogApp(slotIndex, catalogId) {
  const item = APP_CATALOG.find(x => x.id === catalogId);
  if (item && slotIndex !== null) {
    appsList[slotIndex] = { ...item };
    saveAppsLocally();
    renderApps();
    showToast(`✓ Assigned ${item.name} to Slot ${slotIndex + 1}`);
    closeSlotChooser();
  }
}

function saveCustomAppForSlot(slotIndex) {
  const name = document.getElementById('customNameInput').value.trim();
  const cmd = document.getElementById('customCmdInput').value.trim();
  if (name && cmd && slotIndex !== null) {
    appsList[slotIndex] = {
      id: 'custom_' + Date.now(),
      name: name,
      icon: 'terminal',
      command: cmd
    };
    saveAppsLocally();
    renderApps();
    showToast(`✓ Assigned ${name} to Slot ${slotIndex + 1}`);
    closeSlotChooser();
  }
}
