// Funobotz Companions System for FUNOBOTZ: THE LOST CORE
// Petalo [1], Quacky [2], Tiko [3], Tolly [4]

class FunobotManager {
  constructor(scene, player) {
    this.scene = scene;
    this.player = player;
    this.bots = {};
    this.activeBotId = 'petalo';
    this.isAbilityActive = false;
    this.abilityTimer = 0;

    this.createBots();
    this.setActiveBot('petalo');
  }

  createBots() {
    this.bots['petalo'] = this.createPetalo();
    this.bots['quacky'] = this.createQuacky();
    this.bots['tiko'] = this.createTiko();
    this.bots['tolly'] = this.createTolly();

    // Add all bot meshes to the scene
    Object.values(this.bots).forEach(bot => {
      this.scene.add(bot.mesh);
      bot.mesh.visible = false;
    });
  }

  createPetalo() {
    const group = new THREE.Group();
    const goldMat = new THREE.MeshStandardMaterial({
      color: 0xfbbf24,
      emissive: 0xd97706,
      emissiveIntensity: 0.3,
      metalness: 0.6,
      roughness: 0.3
    });
    const centerMat = new THREE.MeshBasicMaterial({ color: 0xffffff });

    // Sphere Core
    const core = new THREE.Mesh(new THREE.SphereGeometry(0.55, 16, 16), goldMat);
    group.add(core);

    // Glowing Eye
    const eye = new THREE.Mesh(new THREE.SphereGeometry(0.2, 12, 12), centerMat);
    eye.position.set(0, 0, 0.45);
    group.add(eye);

    // 6 Flower Petals
    const petalGeo = new THREE.ConeGeometry(0.22, 0.65, 5);
    petalGeo.rotateX(Math.PI / 2);
    group.petals = [];
    for (let i = 0; i < 6; i++) {
      const angle = (i / 6) * Math.PI * 2;
      const petal = new THREE.Mesh(petalGeo, goldMat);
      petal.position.set(Math.cos(angle) * 0.65, Math.sin(angle) * 0.65, 0);
      petal.rotation.z = angle - Math.PI / 2;
      group.add(petal);
      group.petals.push(petal);
    }

    // Solar Aura PointLight
    const light = new THREE.PointLight(0xfbbf24, 1.8, 16);
    group.add(light);
    group.auraLight = light;

    return {
      id: 'petalo',
      name: 'Petalo',
      key: '1',
      domain: 'Light & Signalling',
      desc: 'Emits a luminous golden aura that illuminates dark caves and activates photosensitive switches.',
      mesh: group,
      color: 0xfbbf24
    };
  }

  createQuacky() {
    const group = new THREE.Group();
    const cyanMat = new THREE.MeshStandardMaterial({
      color: 0x00f0ff,
      emissive: 0x0284c7,
      emissiveIntensity: 0.25,
      metalness: 0.5,
      roughness: 0.3
    });
    const beakMat = new THREE.MeshStandardMaterial({ color: 0xf97316, metalness: 0.2 });

    // Aerodynamic Body
    const body = new THREE.Mesh(new THREE.CylinderGeometry(0.35, 0.5, 0.8, 8), cyanMat);
    body.rotation.x = Math.PI / 2;
    group.add(body);

    // Duck Bill / Beak
    const beak = new THREE.Mesh(new THREE.ConeGeometry(0.25, 0.45, 6), beakMat);
    beak.rotation.x = Math.PI / 2;
    beak.position.set(0, -0.05, 0.65);
    group.add(beak);

    // Jet Thrusters
    const thrusterMat = new THREE.MeshBasicMaterial({ color: 0x38bdf8 });
    const tLeft = new THREE.Mesh(new THREE.CylinderGeometry(0.12, 0.15, 0.3, 8), thrusterMat);
    tLeft.rotation.x = Math.PI / 2;
    tLeft.position.set(-0.38, 0, -0.45);
    group.add(tLeft);

    const tRight = new THREE.Mesh(new THREE.CylinderGeometry(0.12, 0.15, 0.3, 8), thrusterMat);
    tRight.rotation.x = Math.PI / 2;
    tRight.position.set(0.38, 0, -0.45);
    group.add(tRight);

    // Thruster flame light
    const light = new THREE.PointLight(0x00f0ff, 1.5, 12);
    group.add(light);
    group.auraLight = light;

    return {
      id: 'quacky',
      name: 'Quacky',
      key: '2',
      domain: 'Movement & Delivery',
      desc: 'Dashes forward on reconnaissance, discovers hidden paths, and dissolves forest bramble barriers.',
      mesh: group,
      color: 0x00f0ff
    };
  }

  createTiko() {
    const group = new THREE.Group();
    const orangeMat = new THREE.MeshStandardMaterial({
      color: 0xf97316,
      emissive: 0xc2410c,
      emissiveIntensity: 0.2,
      metalness: 0.7,
      roughness: 0.4
    });
    const brassMat = new THREE.MeshStandardMaterial({ color: 0xd97706, metalness: 0.9, roughness: 0.2 });

    // Robotic Cube Body
    const body = new THREE.Mesh(new THREE.BoxGeometry(0.8, 0.8, 0.8), orangeMat);
    group.add(body);

    // Front Brass Gear
    const gear = new THREE.Mesh(new THREE.CylinderGeometry(0.3, 0.3, 0.1, 8), brassMat);
    gear.rotation.x = Math.PI / 2;
    gear.position.set(0, 0, 0.45);
    group.add(gear);
    group.gear = gear;

    // Articulating Mechanical Kinetic Arm
    const armBase = new THREE.Group();
    const segment = new THREE.Mesh(new THREE.BoxGeometry(0.15, 0.55, 0.15), brassMat);
    segment.position.y = 0.3;
    armBase.add(segment);
    armBase.position.set(0.48, 0.2, 0);
    group.add(armBase);
    group.arm = armBase;

    // Amber indicator light
    const light = new THREE.PointLight(0xf97316, 1.2, 10);
    group.add(light);
    group.auraLight = light;

    return {
      id: 'tiko',
      name: 'Tiko',
      key: '3',
      domain: 'Object Manipulation',
      desc: 'Manipulates mechanical linkages, rotates drive gears, and extends bridges across chasms.',
      mesh: group,
      color: 0xf97316
    };
  }

  createTolly() {
    const group = new THREE.Group();
    const blueMat = new THREE.MeshStandardMaterial({
      color: 0x2563eb,
      emissive: 0x1d4ed8,
      emissiveIntensity: 0.3,
      metalness: 0.8,
      roughness: 0.3
    });
    const visorMat = new THREE.MeshBasicMaterial({ color: 0x10b981 });

    // Hexagonal Body
    const body = new THREE.Mesh(new THREE.CylinderGeometry(0.5, 0.5, 0.9, 6), blueMat);
    group.add(body);

    // Security Scanner Visor Bar
    const scanner = new THREE.Mesh(new THREE.BoxGeometry(0.75, 0.15, 0.2), visorMat);
    scanner.position.set(0, 0.15, 0.45);
    group.add(scanner);

    // Tollgate Barrier Arm
    const gateArm = new THREE.Mesh(new THREE.BoxGeometry(0.8, 0.1, 0.1), new THREE.MeshStandardMaterial({ color: 0xfacc15 }));
    gateArm.position.set(0, -0.2, 0.5);
    group.add(gateArm);
    group.gateArm = gateArm;

    // Security Green Aura Light
    const light = new THREE.PointLight(0x10b981, 1.4, 12);
    group.add(light);
    group.auraLight = light;

    return {
      id: 'tolly',
      name: 'Tolly',
      key: '4',
      domain: 'Tollgate & Access',
      desc: 'Operates toll barriers, unlocks checkpoints, and regulates passage through restricted gates.',
      mesh: group,
      color: 0x2563eb
    };
  }

  setActiveBot(botId) {
    if (!this.bots[botId]) return;
    this.activeBotId = botId;

    Object.keys(this.bots).forEach(id => {
      this.bots[id].mesh.visible = (id === botId);
    });

    window.audioManager.playInteract();
    return this.bots[botId];
  }

  getActiveBot() {
    return this.bots[this.activeBotId];
  }

  useAbility() {
    const bot = this.getActiveBot();
    this.isAbilityActive = true;
    this.abilityTimer = 1.0;
    window.audioManager.playAbility(bot.id);
    return bot.id;
  }

  update(delta, time) {
    const active = this.getActiveBot();
    if (!active) return;

    const pPos = this.player.getPosition();
    const mesh = active.mesh;

    // Floating kinematic shoulder follow
    const targetX = pPos.x + 1.4;
    const targetY = pPos.y + 2.0 + Math.sin(time * 3.5) * 0.18;
    const targetZ = pPos.z - 0.5;

    // If ability active (e.g. Quacky rocket dash)
    if (this.isAbilityActive) {
      this.abilityTimer -= delta;
      if (active.id === 'quacky') {
        mesh.position.z += 22 * delta; // Dash forward!
      }
      if (this.abilityTimer <= 0) {
        this.isAbilityActive = false;
      }
    } else {
      mesh.position.x += (targetX - mesh.position.x) * 10 * delta;
      mesh.position.y += (targetY - mesh.position.y) * 10 * delta;
      mesh.position.z += (targetZ - mesh.position.z) * 10 * delta;
    }

    // Micro-animations per robot
    if (active.id === 'petalo' && active.mesh.petals) {
      active.mesh.petals.forEach((p, i) => {
        p.rotation.z += delta * 1.5 * (i % 2 === 0 ? 1 : -1);
      });
      active.mesh.auraLight.intensity = 1.8 + Math.sin(time * 6) * 0.4;
    } else if (active.id === 'tiko' && active.mesh.gear) {
      active.mesh.gear.rotation.z += delta * 4;
      active.mesh.arm.rotation.z = Math.sin(time * 4) * 0.4;
    } else if (active.id === 'tolly' && active.mesh.gateArm) {
      active.mesh.gateArm.rotation.z = Math.sin(time * 2) * 0.25;
    }
  }
}

window.FunobotManager = FunobotManager;
