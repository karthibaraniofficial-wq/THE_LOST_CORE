// Interactive In-World Obstacles for FUNOBOTZ: THE LOST CORE
// Brambles, Rainbow Bridge, Mystery Cave Runes, Ancient Vault Gate, and The Lost Core

class ObstacleManager {
  constructor(scene) {
    this.scene = scene;
    this.obstacles = {};
    this.particles = [];

    this.initBrambles();
    this.initRainbowBridge();
    this.initMysteryCave();
    this.initAncientVault();
    this.initLostCoreAltar();
  }

  // --- OBSTACLE 1: HIDDEN FOREST BRAMBLES ---
  initBrambles() {
    const group = new THREE.Group();
    const brambleMat = new THREE.MeshStandardMaterial({
      color: 0x4a2810,
      roughness: 0.9,
      flatShading: true
    });
    const thornMat = new THREE.MeshStandardMaterial({ color: 0x225522, flatShading: true });

    // Multi-tangled vine branches
    for (let i = 0; i < 12; i++) {
      const branch = new THREE.Mesh(new THREE.CylinderGeometry(0.2, 0.35, 5, 5), brambleMat);
      branch.position.set((Math.random() - 0.5) * 8, 2 + (Math.random() - 0.5) * 2, (Math.random() - 0.5) * 2);
      branch.rotation.set(Math.random() * Math.PI, Math.random() * Math.PI, Math.random() * Math.PI);
      branch.castShadow = true;
      group.add(branch);
    }

    // Thorn leaves
    for (let i = 0; i < 16; i++) {
      const leaf = new THREE.Mesh(new THREE.ConeGeometry(0.3, 0.7, 4), thornMat);
      leaf.position.set((Math.random() - 0.5) * 8, 1.5 + Math.random() * 2.5, (Math.random() - 0.5) * 2);
      leaf.rotation.set(Math.random(), Math.random(), Math.random());
      group.add(leaf);
    }

    group.position.set(0, 0, 65);
    this.scene.add(group);

    this.obstacles['bramble'] = {
      name: 'Forest Bramble Barrier',
      type: 'bramble',
      mesh: group,
      requiredBot: 'quacky',
      hint: 'These thick brambles need swift cutting and scouting! Try Quacky [2]!',
      solved: false,
      z: 65,
      triggerDist: 9.0
    };
  }

  // --- OBSTACLE 2: RAINBOW BRIDGE CHASM ---
  initRainbowBridge() {
    const group = new THREE.Group();

    // Deep Canyon Gap Visual (Dark chasm drop at z = 95 to 115)
    const chasmMat = new THREE.MeshBasicMaterial({ color: 0x050b14 });
    const chasm = new THREE.Mesh(new THREE.PlaneGeometry(16, 20), chasmMat);
    chasm.rotation.x = -Math.PI / 2;
    chasm.position.set(0, -1.0, 105);
    this.scene.add(chasm);

    // Mechanical Gear Control Pedestal
    const pedMat = new THREE.MeshStandardMaterial({ color: 0x334155, roughness: 0.5 });
    const gearPed = new THREE.Mesh(new THREE.CylinderGeometry(0.8, 1.0, 2.2, 8), pedMat);
    gearPed.position.set(5.5, 1.1, 93);
    group.add(gearPed);

    const gearMat = new THREE.MeshStandardMaterial({ color: 0xd97706, metalness: 0.9 });
    const bigGear = new THREE.Mesh(new THREE.CylinderGeometry(0.7, 0.7, 0.2, 12), gearMat);
    bigGear.rotation.x = Math.PI / 2;
    bigGear.position.set(5.5, 2.3, 93);
    group.add(bigGear);
    group.gear = bigGear;

    // Retracted Bridge Planks (Initially scale.z = 0.05, extends to 20m)
    const bridgeGroup = new THREE.Group();
    const colors = [0xef4444, 0xf97316, 0xeab308, 0x22c55e, 0x3b82f6, 0xa855f7];
    for (let i = 0; i < 6; i++) {
      const plank = new THREE.Mesh(
        new THREE.BoxGeometry(1.2, 0.4, 20),
        new THREE.MeshStandardMaterial({ color: colors[i], roughness: 0.3, metalness: 0.4 })
      );
      plank.position.set(-3.6 + i * 1.45, 0.2, 10);
      plank.castShadow = true;
      plank.receiveShadow = true;
      bridgeGroup.add(plank);
    }

    bridgeGroup.position.set(0, 0, 95);
    bridgeGroup.scale.z = 0.05; // Retracted
    this.scene.add(bridgeGroup);
    group.bridgeMesh = bridgeGroup;

    group.position.set(0, 0, 0);
    this.scene.add(group);

    this.obstacles['bridge'] = {
      name: 'Rainbow Bridge Mechanism',
      type: 'bridge',
      mesh: group,
      bridgeMesh: bridgeGroup,
      gear: bigGear,
      requiredBot: 'tiko',
      hint: 'This mechanism requires heavy mechanical manipulation! Try Tiko [3]!',
      solved: false,
      z: 94,
      triggerDist: 9.0
    };
  }

  // --- OBSTACLE 3: MYSTERY CAVE & RUNES ---
  initMysteryCave() {
    const group = new THREE.Group();
    const caveMat = new THREE.MeshStandardMaterial({
      color: 0x1e293b,
      roughness: 0.9,
      flatShading: true
    });

    // Cavern Entrance Arch & Pillars
    const p1 = new THREE.Mesh(new THREE.BoxGeometry(3, 16, 4), caveMat);
    p1.position.set(-6, 8, 140);
    group.add(p1);

    const p2 = new THREE.Mesh(new THREE.BoxGeometry(3, 16, 4), caveMat);
    p2.position.set(6, 8, 140);
    group.add(p2);

    const roof = new THREE.Mesh(new THREE.BoxGeometry(15, 4, 18), caveMat);
    roof.position.set(0, 16, 147);
    group.add(roof);

    // Ancient Carved Wall Runes (Emissive switches)
    const runeMat = new THREE.MeshStandardMaterial({
      color: 0x334155,
      emissive: 0x0f172a,
      roughness: 0.4
    });
    const rune1 = new THREE.Mesh(new THREE.BoxGeometry(0.2, 2.5, 2.5), runeMat);
    rune1.position.set(-4.4, 7, 144);
    group.add(rune1);

    const rune2 = new THREE.Mesh(new THREE.BoxGeometry(0.2, 2.5, 2.5), runeMat);
    rune2.position.set(4.4, 7, 144);
    group.add(rune2);

    // Interior Cavern Light (Off by default)
    const caveLight = new THREE.PointLight(0x00f0ff, 0, 30);
    caveLight.position.set(0, 8, 148);
    group.add(caveLight);

    group.position.set(0, 0, 0);
    this.scene.add(group);

    this.obstacles['cave'] = {
      name: 'Mystery Cave Runes',
      type: 'cave',
      mesh: group,
      runeMat: runeMat,
      caveLight: caveLight,
      requiredBot: 'petalo',
      hint: 'It is pitch black inside this cave! We need bright light! Try Petalo [1]!',
      solved: false,
      z: 140,
      triggerDist: 9.0
    };
  }

  // --- OBSTACLE 4: ANCIENT VAULT SECURITY GATE ---
  initAncientVault() {
    const group = new THREE.Group();
    const vaultMat = new THREE.MeshStandardMaterial({ color: 0x475569, metalness: 0.5, roughness: 0.5 });
    const gateMat = new THREE.MeshStandardMaterial({ color: 0x0f172a, metalness: 0.8, roughness: 0.2 });

    // Gate Portal Frame
    const arch = new THREE.Mesh(new THREE.BoxGeometry(16, 18, 4), vaultMat);
    arch.position.set(0, 9, 185);
    group.add(arch);

    // Access Terminal Pillar
    const terminal = new THREE.Mesh(new THREE.BoxGeometry(1.0, 2.2, 1.0), new THREE.MeshStandardMaterial({ color: 0x1e293b }));
    terminal.position.set(5.5, 1.1, 181);
    group.add(terminal);

    const screen = new THREE.Mesh(new THREE.BoxGeometry(0.6, 0.4, 0.1), new THREE.MeshBasicMaterial({ color: 0xef4444 }));
    screen.position.set(5.5, 1.8, 180.45);
    group.add(screen);
    group.screen = screen;

    // Sliding Iron Vault Gate
    const gate = new THREE.Mesh(new THREE.BoxGeometry(8, 12, 1.0), gateMat);
    gate.position.set(0, 6, 185);
    gate.castShadow = true;
    group.add(gate);
    group.gate = gate;

    group.position.set(0, 0, 0);
    this.scene.add(group);

    this.obstacles['vault'] = {
      name: 'Ancient Vault Gate',
      type: 'vault',
      mesh: group,
      gate: gate,
      screen: screen,
      requiredBot: 'tolly',
      hint: 'This high-security toll barrier needs digital access codes! Try Tolly [4]!',
      solved: false,
      z: 182,
      triggerDist: 9.0
    };
  }

  // --- OBSTACLE 5: CORE CHAMBER & THE LOST CORE ---
  initLostCoreAltar() {
    const group = new THREE.Group();
    const daisMat = new THREE.MeshStandardMaterial({ color: 0x334155, roughness: 0.4, metalness: 0.6 });

    // Sacred Temple Dais at z = 215
    const dais = new THREE.Mesh(new THREE.CylinderGeometry(10, 11, 1.5, 16), daisMat);
    dais.position.set(0, 0.75, 215);
    group.add(dais);

    // Altar Pedestal
    const altar = new THREE.Mesh(new THREE.CylinderGeometry(1.5, 2.0, 2.5, 8), daisMat);
    altar.position.set(0, 2.5, 215);
    group.add(altar);

    // Floating, Rotating, Pulsing Lost Core (Icosahedron Crystal)
    const coreMat = new THREE.MeshStandardMaterial({
      color: 0x00f0ff,
      emissive: 0x38bdf8,
      emissiveIntensity: 0.9,
      roughness: 0.1,
      metalness: 0.9,
      flatShading: true
    });
    const core = new THREE.Mesh(new THREE.IcosahedronGeometry(1.2, 1), coreMat);
    core.position.set(0, 5.2, 215);
    group.add(core);
    group.core = core;

    // Orbiting Rings
    const ringMat = new THREE.MeshBasicMaterial({ color: 0xfbbf24, side: THREE.DoubleSide });
    const ring1 = new THREE.Mesh(new THREE.TorusGeometry(2.0, 0.08, 8, 32), ringMat);
    ring1.position.set(0, 5.2, 215);
    group.add(ring1);
    group.ring1 = ring1;

    // Glowing PointLight
    const coreLight = new THREE.PointLight(0x00f0ff, 3.5, 25);
    coreLight.position.set(0, 5.2, 215);
    group.add(coreLight);

    group.position.set(0, 0, 0);
    this.scene.add(group);

    this.obstacles['lost_core'] = {
      name: 'The Lost Core',
      type: 'lost_core',
      mesh: group,
      core: core,
      ring1: ring1,
      coreLight: coreLight,
      solved: false,
      z: 215,
      triggerDist: 5.0
    };
  }

  // --- SOLVE OBSTACLE MECHANICS & VISUALS ---

  solveObstacle(type) {
    const obs = this.obstacles[type];
    if (!obs || obs.solved) return;
    obs.solved = true;
    window.audioManager.playObstacleClear();

    if (type === 'bramble') {
      // Dissolve animation: scale down and fade
      let t = 0;
      const interval = setInterval(() => {
        t += 0.05;
        obs.mesh.scale.set(1 - t, 1 - t, 1 - t);
        if (t >= 1) {
          clearInterval(interval);
          obs.mesh.visible = false;
        }
      }, 30);
    } else if (type === 'bridge') {
      // Extend rainbow bridge across chasm
      let s = 0.05;
      const interval = setInterval(() => {
        s += 0.04;
        obs.bridgeMesh.scale.z = Math.min(1.0, s);
        obs.gear.rotation.z += 0.3;
        if (s >= 1.0) clearInterval(interval);
      }, 30);
    } else if (type === 'cave') {
      // Light up wall runes and cavern interior
      obs.runeMat.emissive.setHex(0x00f0ff);
      obs.runeMat.emissiveIntensity = 1.0;
      obs.caveLight.intensity = 2.5;
    } else if (type === 'vault') {
      // Terminal turns green, gate slides upward
      obs.screen.material.color.setHex(0x10b981);
      let y = 6;
      const interval = setInterval(() => {
        y += 0.25;
        obs.gate.position.y = y;
        if (y >= 16) clearInterval(interval);
      }, 30);
    } else if (type === 'lost_core') {
      // Collect core!
      obs.core.visible = false;
      obs.ring1.visible = false;
      obs.coreLight.intensity = 8.0;
      window.audioManager.playVictory();
    }
  }

  update(delta, time) {
    // Animate the Lost Core rotation
    const coreObs = this.obstacles['lost_core'];
    if (coreObs && coreObs.core) {
      coreObs.core.rotation.y = time * 0.8;
      coreObs.core.rotation.x = Math.sin(time * 0.5) * 0.3;
      coreObs.core.position.y = 5.2 + Math.sin(time * 2.5) * 0.25;
      coreObs.ring1.rotation.x = time * 1.2;
      coreObs.ring1.rotation.y = time * 0.6;
    }

    // Gentle gear rotation on solved bridge
    const bridgeObs = this.obstacles['bridge'];
    if (bridgeObs && bridgeObs.solved) {
      bridgeObs.gear.rotation.z += delta * 0.5;
    }
  }
}

window.ObstacleManager = ObstacleManager;
