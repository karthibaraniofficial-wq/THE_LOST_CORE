// Main Game Application & State Machine for FUNOBOTZ: THE LOST CORE

class GameApp {
  constructor() {
    this.container = document.getElementById('canvas-container');
    this.scene = null;
    this.camera = null;
    this.renderer = null;
    
    this.world = null;
    this.character = null;
    this.funobotz = null;
    this.obstacles = null;

    // Authoritative Mission States
    this.STATES = {
      NOT_STARTED: 0,
      ACTIVE: 1,
      FOREST: 2,
      BRIDGE: 3,
      CAVE: 4,
      VAULT: 5,
      CORE: 6,
      COMPLETE: 7
    };
    this.currentState = this.STATES.NOT_STARTED;

    // Input States
    this.keys = {};
    this.cameraOrbit = { yaw: 0, pitch: 0.28, distance: 9.5 };
    this.isDragging = false;
    this.prevMouse = { x: 0, y: 0 };
    this.isGameStarted = false;

    this.clock = new THREE.Clock();
    this.initThree();
    this.initWorldAndEntities();
    this.initInputListeners();
    this.updateHUD();
    this.animate();
  }

  initThree() {
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(55, window.innerWidth / window.innerHeight, 0.1, 500);

    this.renderer = new THREE.WebGLRenderer({ antialias: true, powerPreference: 'high-performance' });
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    this.renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    this.renderer.shadowMap.enabled = true;
    this.renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    this.container.appendChild(this.renderer.domElement);

    window.addEventListener('resize', () => this.onWindowResize());
  }

  initWorldAndEntities() {
    this.world = new World(this.scene);
    this.character = new Character(this.scene);
    this.funobotz = new FunobotManager(this.scene, this.character);
    this.obstacles = new ObstacleManager(this.scene);
  }

  initInputListeners() {
    // Keyboard inputs
    window.addEventListener('keydown', (e) => {
      this.keys[e.code] = true;

      // Companion Hotkeys
      if (e.key === '1') this.selectBot('petalo');
      if (e.key === '2') this.selectBot('quacky');
      if (e.key === '3') this.selectBot('tiko');
      if (e.key === '4') this.selectBot('tolly');

      // Interact Key [E]
      if (e.code === 'KeyE') this.handleInteraction();

      // Ability Key [F]
      if (e.code === 'KeyF') this.handleAbilityUsage();
    });

    window.addEventListener('keyup', (e) => {
      this.keys[e.code] = false;
    });

    // Mouse drag for camera orbit
    window.addEventListener('mousedown', (e) => {
      if (e.target.tagName === 'BUTTON' || e.target.closest('.modal-dialog')) return;
      this.isDragging = true;
      this.prevMouse.x = e.clientX;
      this.prevMouse.y = e.clientY;
    });

    window.addEventListener('mousemove', (e) => {
      if (!this.isDragging) return;
      const dx = e.clientX - this.prevMouse.x;
      const dy = e.clientY - this.prevMouse.y;
      this.cameraOrbit.yaw -= dx * 0.005;
      this.cameraOrbit.pitch = Math.max(0.08, Math.min(0.85, this.cameraOrbit.pitch + dy * 0.005));
      this.prevMouse.x = e.clientX;
      this.prevMouse.y = e.clientY;
    });

    window.addEventListener('mouseup', () => {
      this.isDragging = false;
    });

    // Mouse wheel zoom
    window.addEventListener('wheel', (e) => {
      this.cameraOrbit.distance = Math.max(5.0, Math.min(18.0, this.cameraOrbit.distance + e.deltaY * 0.01));
    });
  }

  selectBot(botId) {
    const bot = this.funobotz.setActiveBot(botId);
    if (!bot) return;

    // Update UI companion slots
    document.querySelectorAll('.slot-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.id === botId);
    });

    // Update companion HUD card
    document.getElementById('hud-bot-name').innerText = bot.name;
    document.getElementById('hud-bot-key').innerText = `[${bot.key}]`;
    document.getElementById('hud-bot-domain').innerText = bot.domain;
    document.getElementById('hud-bot-desc').innerText = `[F] ${bot.desc}`;
  }

  handleInteraction() {
    const pPos = this.character.getPosition();

    // Check Gateway Beacon (z ≈ 0)
    if (this.currentState === this.STATES.NOT_STARTED && Math.abs(pPos.z - 0) < 5.0 && Math.abs(pPos.x) < 4.0) {
      this.currentState = this.STATES.ACTIVE;
      window.audioManager.playInteract();
      this.showToast('Grand Gateway Beacon Activated! Companions Recruited!');
      this.updateHUD();
      return;
    }

    // Check Lost Core Altar (z ≈ 215)
    if (this.currentState === this.STATES.CORE && Math.abs(pPos.z - 215) < 6.0 && Math.abs(pPos.x) < 4.0) {
      this.currentState = this.STATES.COMPLETE;
      this.obstacles.solveObstacle('lost_core');
      this.updateHUD();
      document.getElementById('victory-modal').classList.add('show');
      return;
    }
  }

  handleAbilityUsage() {
    const botId = this.funobotz.useAbility();
    const pPos = this.character.getPosition();

    // Zone 1: Forest Brambles (z ≈ 65)
    if (Math.abs(pPos.z - 65) < 10.0 && !this.obstacles.obstacles['bramble'].solved) {
      if (botId === 'quacky') {
        this.obstacles.solveObstacle('bramble');
        this.currentState = this.STATES.BRIDGE;
        this.showToast('Quacky dissolved the forest brambles! Path open!');
        this.updateHUD();
      } else {
        this.showToast(this.obstacles.obstacles['bramble'].hint, true);
      }
      return;
    }

    // Zone 2: Rainbow Bridge (z ≈ 94)
    if (Math.abs(pPos.z - 94) < 10.0 && !this.obstacles.obstacles['bridge'].solved) {
      if (botId === 'tiko') {
        this.obstacles.solveObstacle('bridge');
        this.currentState = this.STATES.CAVE;
        this.showToast('Tiko extended the Rainbow Bridge! Chasm crossed!');
        this.updateHUD();
      } else {
        this.showToast(this.obstacles.obstacles['bridge'].hint, true);
      }
      return;
    }

    // Zone 3: Mystery Cave (z ≈ 140)
    if (Math.abs(pPos.z - 140) < 10.0 && !this.obstacles.obstacles['cave'].solved) {
      if (botId === 'petalo') {
        this.obstacles.solveObstacle('cave');
        this.currentState = this.STATES.VAULT;
        this.showToast('Petalo illuminated the runes and dispelled the cavern dark!');
        this.updateHUD();
      } else {
        this.showToast(this.obstacles.obstacles['cave'].hint, true);
      }
      return;
    }

    // Zone 4: Ancient Vault (z ≈ 182)
    if (Math.abs(pPos.z - 182) < 10.0 && !this.obstacles.obstacles['vault'].solved) {
      if (botId === 'tolly') {
        this.obstacles.solveObstacle('vault');
        this.currentState = this.STATES.CORE;
        this.showToast('Tolly authorized security access! Vault gate open!');
        this.updateHUD();
      } else {
        this.showToast(this.obstacles.obstacles['vault'].hint, true);
      }
      return;
    }
  }

  showToast(message, isWarning = false) {
    const toast = document.getElementById('feedback-toast');
    toast.innerText = message;
    toast.className = `feedback-toast show ${isWarning ? 'warning' : ''}`;
    clearTimeout(this.toastTimer);
    this.toastTimer = setTimeout(() => {
      toast.classList.remove('show');
    }, 3800);
  }

  updateHUD() {
    const objEl = document.getElementById('hud-objective');
    const statusEl = document.getElementById('hud-status');

    switch (this.currentState) {
      case this.STATES.NOT_STARTED:
        objEl.innerText = 'Step forward into the glowing Grand Gateway Beacon.';
        statusEl.innerText = '[MISSION_NOT_STARTED]';
        break;
      case this.STATES.ACTIVE:
        objEl.innerText = 'Advance to the Funobotz Hub [z=30] and approach the Forest.';
        statusEl.innerText = '[MISSION_ACTIVE]';
        break;
      case this.STATES.FOREST:
        objEl.innerText = 'Select Quacky [2] and press [F] to dissolve the Brambles [z=65].';
        statusEl.innerText = '[FOREST_OBJECTIVE]';
        break;
      case this.STATES.BRIDGE:
        objEl.innerText = 'Select Tiko [3] and press [F] to extend the Rainbow Bridge [z=94].';
        statusEl.innerText = '[BRIDGE_OBJECTIVE]';
        break;
      case this.STATES.CAVE:
        objEl.innerText = 'Select Petalo [1] and press [F] to illuminate the Mystery Cave [z=140].';
        statusEl.innerText = '[CAVE_OBJECTIVE]';
        break;
      case this.STATES.VAULT:
        objEl.innerText = 'Select Tolly [4] and press [F] to open the Ancient Vault [z=182].';
        statusEl.innerText = '[VAULT_OBJECTIVE]';
        break;
      case this.STATES.CORE:
        objEl.innerText = 'Approach the sacred altar [z=215] and press [E] to recover the Lost Core!';
        statusEl.innerText = '[CORE_OBJECTIVE]';
        break;
      case this.STATES.COMPLETE:
        objEl.innerText = '★ Mission Accomplished! The Discovery World is saved! ★';
        statusEl.innerText = '[MISSION_COMPLETE]';
        break;
    }
  }

  checkInteractionPrompts() {
    const pPos = this.character.getPosition();
    const prompt = document.getElementById('interact-prompt');
    const keyEl = prompt.querySelector('.prompt-key');
    const textEl = prompt.querySelector('.prompt-text');

    // Gateway Beacon prompt
    if (this.currentState === this.STATES.NOT_STARTED && Math.abs(pPos.z - 0) < 5.0 && Math.abs(pPos.x) < 4.0) {
      keyEl.innerText = 'E';
      textEl.innerText = 'Activate Gateway Beacon';
      prompt.classList.add('show');
      return;
    }

    // Lost Core prompt
    if (this.currentState === this.STATES.CORE && Math.abs(pPos.z - 215) < 6.0 && Math.abs(pPos.x) < 4.0) {
      keyEl.innerText = 'E';
      textEl.innerText = 'Recover The Lost Core';
      prompt.classList.add('show');
      return;
    }

    // Bramble prompt
    if (Math.abs(pPos.z - 65) < 9.0 && !this.obstacles.obstacles['bramble'].solved) {
      keyEl.innerText = 'F';
      textEl.innerText = 'Use Ability on Bramble Barrier';
      prompt.classList.add('show');
      return;
    }

    // Bridge prompt
    if (Math.abs(pPos.z - 94) < 9.0 && !this.obstacles.obstacles['bridge'].solved) {
      keyEl.innerText = 'F';
      textEl.innerText = 'Use Ability on Bridge Mechanism';
      prompt.classList.add('show');
      return;
    }

    // Cave prompt
    if (Math.abs(pPos.z - 140) < 9.0 && !this.obstacles.obstacles['cave'].solved) {
      keyEl.innerText = 'F';
      textEl.innerText = 'Use Ability on Dark Cave Runes';
      prompt.classList.add('show');
      return;
    }

    // Vault prompt
    if (Math.abs(pPos.z - 182) < 9.0 && !this.obstacles.obstacles['vault'].solved) {
      keyEl.innerText = 'F';
      textEl.innerText = 'Use Ability on Vault Security Gate';
      prompt.classList.add('show');
      return;
    }

    prompt.classList.remove('show');
  }

  animate() {
    requestAnimationFrame(() => this.animate());

    const delta = Math.min(0.1, this.clock.getDelta());
    const time = this.clock.getElapsedTime();

    // Player Movement Input Calculation
    const inputDir = new THREE.Vector3();
    if (this.keys['KeyW'] || this.keys['ArrowUp']) inputDir.z += 1;
    if (this.keys['KeyS'] || this.keys['ArrowDown']) inputDir.z -= 1;
    if (this.keys['KeyA'] || this.keys['ArrowLeft']) inputDir.x += 1;
    if (this.keys['KeyD'] || this.keys['ArrowRight']) inputDir.x -= 1;

    // Rotate input direction by camera yaw
    if (inputDir.lengthSq() > 0) {
      inputDir.applyAxisAngle(new THREE.Vector3(0, 1, 0), this.cameraOrbit.yaw);
    }

    const isSprinting = !!(this.keys['ShiftLeft'] || this.keys['ShiftRight']);
    const isJumpPressed = !!this.keys['Space'];

    // Update Entities
    if (this.character) {
      this.character.update(delta, inputDir, isSprinting, isJumpPressed);
    }
    if (this.funobotz) {
      this.funobotz.update(delta, time);
    }
    if (this.obstacles) {
      this.obstacles.update(delta, time);
    }
    if (this.world) {
      this.world.update(time);
    }

    // Advance to forest if player moves past Hub in active state
    if (this.currentState === this.STATES.ACTIVE && this.character.getPosition().z > 40) {
      this.currentState = this.STATES.FOREST;
      this.updateHUD();
    }

    // Update Third-Person Chase Camera
    this.updateCamera();

    // Check Proximity Prompts
    this.checkInteractionPrompts();

    // Render
    this.renderer.render(this.scene, this.camera);
  }

  updateCamera() {
    const pPos = this.character.getPosition();
    const cosPitch = Math.cos(this.cameraOrbit.pitch);
    const sinPitch = Math.sin(this.cameraOrbit.pitch);

    const camX = pPos.x - Math.sin(this.cameraOrbit.yaw) * this.cameraOrbit.distance * cosPitch;
    const camY = pPos.y + 2.0 + sinPitch * this.cameraOrbit.distance;
    const camZ = pPos.z - Math.cos(this.cameraOrbit.yaw) * this.cameraOrbit.distance * cosPitch;

    this.camera.position.lerp(new THREE.Vector3(camX, camY, camZ), 0.12);
    this.camera.lookAt(pPos.x, pPos.y + 1.8, pPos.z);
  }

  onWindowResize() {
    this.camera.aspect = window.innerWidth / window.innerHeight;
    this.camera.updateProjectionMatrix();
    this.renderer.setSize(window.innerWidth, window.innerHeight);
  }
}

// Global Start Function
window.startGame = function() {
  document.getElementById('start-modal').classList.add('hidden');
  window.audioManager.init();
  window.audioManager.startBGM();
  window.gameApp = new GameApp();
};

window.restartGame = function() {
  window.location.reload();
};
