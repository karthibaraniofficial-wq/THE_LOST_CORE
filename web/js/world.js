// 3D Discovery World Environment for FUNOBOTZ: THE LOST CORE
// Built using Three.js

class World {
  constructor(scene) {
    this.scene = scene;
    this.colliders = [];
    this.animatedObjects = [];
    this.initLighting();
    this.initEnvironment();
    this.initGrandGateway();
    this.initFunobotzHub();
    this.initFoliageAndProps();
  }

  initLighting() {
    // Ambient soft hemisphere light
    const hemiLight = new THREE.HemisphereLight(0xdff0ff, 0x1c2b3a, 0.65);
    hemiLight.position.set(0, 50, 0);
    this.scene.add(hemiLight);

    // Warm directional sun
    const dirLight = new THREE.DirectionalLight(0xfff5e6, 0.9);
    dirLight.position.set(40, 80, 50);
    dirLight.castShadow = true;
    dirLight.shadow.mapSize.width = 2048;
    dirLight.shadow.mapSize.height = 2048;
    dirLight.shadow.camera.near = 0.5;
    dirLight.shadow.camera.far = 300;
    const d = 100;
    dirLight.shadow.camera.left = -d;
    dirLight.shadow.camera.right = d;
    dirLight.shadow.camera.top = d;
    dirLight.shadow.camera.bottom = -d;
    dirLight.shadow.bias = -0.0005;
    this.scene.add(dirLight);

    // Sky fog for atmosphere
    this.scene.fog = new THREE.FogExp2(0x1a2b44, 0.008);
  }

  initEnvironment() {
    // Sky Dome
    const skyGeo = new THREE.SphereGeometry(250, 32, 15);
    const skyMat = new THREE.MeshBasicMaterial({
      color: 0x223854,
      side: THREE.BackSide
    });
    const sky = new THREE.Mesh(skyGeo, skyMat);
    this.scene.add(sky);

    // Main Ground Plateau
    const groundGeo = new THREE.PlaneGeometry(160, 320, 32, 64);
    const groundMat = new THREE.MeshStandardMaterial({
      color: 0x3b824a,
      roughness: 0.85,
      metalness: 0.05,
      flatShading: true
    });
    const ground = new THREE.Mesh(groundGeo, groundMat);
    ground.rotation.x = -Math.PI / 2;
    ground.position.set(0, 0, 110);
    ground.receiveShadow = true;
    this.scene.add(ground);

    // Cobblestone Main Pathway
    const pathGeo = new THREE.PlaneGeometry(8, 280);
    const pathMat = new THREE.MeshStandardMaterial({
      color: 0x94a3b8,
      roughness: 0.7,
      metalness: 0.1,
      flatShading: true
    });
    const path = new THREE.Mesh(pathGeo, pathMat);
    path.rotation.x = -Math.PI / 2;
    path.position.set(0, 0.05, 110);
    path.receiveShadow = true;
    this.scene.add(path);

    // Surrounding Mountain Borders
    this.createMountainRange();
  }

  createMountainRange() {
    const mountainMat = new THREE.MeshStandardMaterial({
      color: 0x243242,
      roughness: 0.9,
      flatShading: true
    });

    for (let i = -10; i <= 10; i++) {
      // Left border cliffs
      const mLeft = new THREE.Mesh(new THREE.ConeGeometry(18 + Math.random() * 8, 35 + Math.random() * 20, 5), mountainMat);
      mLeft.position.set(-65 - Math.random() * 20, 15, i * 28 + 100);
      mLeft.castShadow = true;
      mLeft.receiveShadow = true;
      this.scene.add(mLeft);

      // Right border cliffs
      const mRight = new THREE.Mesh(new THREE.ConeGeometry(18 + Math.random() * 8, 35 + Math.random() * 20, 5), mountainMat);
      mRight.position.set(65 + Math.random() * 20, 15, i * 28 + 100);
      mRight.castShadow = true;
      mRight.receiveShadow = true;
      this.scene.add(mRight);
    }
  }

  initGrandGateway() {
    // Starting Archway at z = 0
    const archMat = new THREE.MeshStandardMaterial({
      color: 0x64748b,
      roughness: 0.6,
      flatShading: true
    });

    // Left Pillar
    const pLeft = new THREE.Mesh(new THREE.BoxGeometry(3, 14, 3), archMat);
    pLeft.position.set(-6, 7, 0);
    pLeft.castShadow = true;
    this.scene.add(pLeft);

    // Right Pillar
    const pRight = new THREE.Mesh(new THREE.BoxGeometry(3, 14, 3), archMat);
    pRight.position.set(6, 7, 0);
    pRight.castShadow = true;
    this.scene.add(pRight);

    // Lintel Beam
    const lintel = new THREE.Mesh(new THREE.BoxGeometry(16, 3, 3.5), archMat);
    lintel.position.set(0, 15, 0);
    lintel.castShadow = true;
    this.scene.add(lintel);

    // Glowing Gateway Beacon Portal Cylinder
    const beaconGeo = new THREE.CylinderGeometry(2.5, 2.5, 12, 16, 1, true);
    const beaconMat = new THREE.MeshBasicMaterial({
      color: 0x00f0ff,
      transparent: true,
      opacity: 0.45,
      side: THREE.DoubleSide
    });
    this.beacon = new THREE.Mesh(beaconGeo, beaconMat);
    this.beacon.position.set(0, 6, 0);
    this.scene.add(this.beacon);

    // Beacon Core Light
    const beaconLight = new THREE.PointLight(0x00f0ff, 2.5, 18);
    beaconLight.position.set(0, 6, 0);
    this.scene.add(beaconLight);

    // Beacon ground ring
    const ringGeo = new THREE.RingGeometry(2.8, 3.4, 32);
    const ringMat = new THREE.MeshBasicMaterial({ color: 0x00f0ff, side: THREE.DoubleSide });
    const ring = new THREE.Mesh(ringGeo, ringMat);
    ring.rotation.x = -Math.PI / 2;
    ring.position.set(0, 0.1, 0);
    this.scene.add(ring);
  }

  initFunobotzHub() {
    // Elevated Central Plaza Dais at z = 30
    const daisMat = new THREE.MeshStandardMaterial({
      color: 0x475569,
      roughness: 0.5,
      flatShading: true
    });
    const dais = new THREE.Mesh(new THREE.CylinderGeometry(14, 15, 1.2, 8), daisMat);
    dais.position.set(0, 0.6, 30);
    dais.receiveShadow = true;
    this.scene.add(dais);

    // Center Emblem
    const emblemGeo = new THREE.CircleGeometry(5, 8);
    const emblemMat = new THREE.MeshBasicMaterial({ color: 0x38bdf8 });
    const emblem = new THREE.Mesh(emblemGeo, emblemMat);
    emblem.rotation.x = -Math.PI / 2;
    emblem.position.set(0, 1.22, 30);
    this.scene.add(emblem);

    // 4 Pedestals for the Funobotz
    const pedestalMat = new THREE.MeshStandardMaterial({ color: 0x1e293b, roughness: 0.4 });
    const coords = [
      { x: -7, z: 27, color: 0xfbbf24, name: 'Petalo [1]' },
      { x: -7, z: 33, color: 0x00f0ff, name: 'Quacky [2]' },
      { x: 7, z: 27, color: 0xf97316, name: 'Tiko [3]' },
      { x: 7, z: 33, color: 0x3b82f6, name: 'Tolly [4]' }
    ];

    coords.forEach(p => {
      const ped = new THREE.Mesh(new THREE.CylinderGeometry(1.2, 1.5, 2, 8), pedestalMat);
      ped.position.set(p.x, 1.6, p.z);
      ped.castShadow = true;
      ped.receiveShadow = true;
      this.scene.add(ped);

      // Pedestal glow ring
      const pRing = new THREE.Mesh(
        new THREE.TorusGeometry(1.3, 0.08, 8, 16),
        new THREE.MeshBasicMaterial({ color: p.color })
      );
      pRing.rotation.x = Math.PI / 2;
      pRing.position.set(p.x, 2.6, p.z);
      this.scene.add(pRing);
    });
  }

  initFoliageAndProps() {
    // Pine Trees
    for (let i = 0; i < 40; i++) {
      const x = (Math.random() > 0.5 ? 1 : -1) * (14 + Math.random() * 38);
      const z = Math.random() * 260;
      this.createTree(x, 0, z);
    }

    // Glowing Crystals
    for (let i = 0; i < 16; i++) {
      const x = (Math.random() > 0.5 ? 1 : -1) * (8 + Math.random() * 12);
      const z = 15 + Math.random() * 220;
      this.createCrystalCluster(x, 0, z, i % 2 === 0 ? 0x00f0ff : 0xa855f7);
    }
  }

  createTree(x, y, z) {
    const group = new THREE.Group();
    // Trunk
    const trunkMat = new THREE.MeshStandardMaterial({ color: 0x5c3d2e, roughness: 0.9 });
    const trunk = new THREE.Mesh(new THREE.CylinderGeometry(0.5, 0.7, 4, 6), trunkMat);
    trunk.position.y = 2;
    trunk.castShadow = true;
    group.add(trunk);

    // Leaves layers
    const leafMat = new THREE.MeshStandardMaterial({ color: 0x1e5e3a, roughness: 0.8, flatShading: true });
    const tier1 = new THREE.Mesh(new THREE.ConeGeometry(3.2, 4.5, 6), leafMat);
    tier1.position.y = 4.5;
    tier1.castShadow = true;
    group.add(tier1);

    const tier2 = new THREE.Mesh(new THREE.ConeGeometry(2.4, 3.8, 6), leafMat);
    tier2.position.y = 6.8;
    tier2.castShadow = true;
    group.add(tier2);

    group.position.set(x, y, z);
    this.scene.add(group);
  }

  createCrystalCluster(x, y, z, color) {
    const group = new THREE.Group();
    const mat = new THREE.MeshStandardMaterial({
      color: color,
      emissive: color,
      emissiveIntensity: 0.6,
      roughness: 0.2,
      metalness: 0.8,
      flatShading: true
    });

    for (let i = 0; i < 4; i++) {
      const h = 1.5 + Math.random() * 2;
      const crystal = new THREE.Mesh(new THREE.ConeGeometry(0.35, h, 5), mat);
      crystal.position.set((Math.random() - 0.5) * 1.2, h / 2, (Math.random() - 0.5) * 1.2);
      crystal.rotation.x = (Math.random() - 0.5) * 0.4;
      crystal.rotation.z = (Math.random() - 0.5) * 0.4;
      crystal.castShadow = true;
      group.add(crystal);
    }

    const light = new THREE.PointLight(color, 1.2, 8);
    light.position.set(0, 1.5, 0);
    group.add(light);

    group.position.set(x, y, z);
    this.scene.add(group);
  }

  update(time) {
    // Pulse beacon portal
    if (this.beacon) {
      this.beacon.rotation.y = time * 0.5;
      this.beacon.scale.y = 1 + Math.sin(time * 2) * 0.08;
    }
  }
}

window.World = World;
