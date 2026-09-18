// 3D Stylized Knight Character Controller for FUNOBOTZ: THE LOST CORE

class Character {
  constructor(scene) {
    this.scene = scene;
    this.mesh = new THREE.Group();
    this.velocity = new THREE.Vector3();
    this.isGrounded = true;
    this.walkCycle = 0;
    this.facingAngle = 0;
    
    this.moveSpeed = 9.0;
    this.sprintMultiplier = 1.6;
    this.jumpForce = 11.5;
    this.gravity = 30.0;

    this.buildKnightModel();
    this.scene.add(this.mesh);
    this.mesh.position.set(0, 0, -8); // Start in front of Grand Gateway
  }

  buildKnightModel() {
    const armorMat = new THREE.MeshStandardMaterial({
      color: 0x64748b,
      metalness: 0.8,
      roughness: 0.35,
      flatShading: true
    });
    const goldMat = new THREE.MeshStandardMaterial({
      color: 0xf59e0b,
      metalness: 0.9,
      roughness: 0.25
    });
    const visorMat = new THREE.MeshBasicMaterial({ color: 0x00f0ff });
    const capeMat = new THREE.MeshStandardMaterial({
      color: 0xdc2626,
      roughness: 0.8,
      side: THREE.DoubleSide
    });

    // Torso / Cuirass
    const torso = new THREE.Mesh(new THREE.BoxGeometry(1.2, 1.4, 0.8), armorMat);
    torso.position.y = 1.6;
    torso.castShadow = true;
    this.mesh.add(torso);

    // Gold Chest Crest
    const crest = new THREE.Mesh(new THREE.BoxGeometry(0.5, 0.5, 0.05), goldMat);
    crest.position.set(0, 1.7, 0.42);
    this.mesh.add(crest);

    // Helmet
    const headGroup = new THREE.Group();
    const helmet = new THREE.Mesh(new THREE.BoxGeometry(0.9, 0.9, 0.9), armorMat);
    helmet.castShadow = true;
    headGroup.add(helmet);

    // Glowing Visor Slot
    const visor = new THREE.Mesh(new THREE.BoxGeometry(0.7, 0.15, 0.05), visorMat);
    visor.position.set(0, 0.05, 0.46);
    headGroup.add(visor);

    // Helmet Plume / Horns
    const plume = new THREE.Mesh(new THREE.ConeGeometry(0.15, 0.6, 4), goldMat);
    plume.position.set(0, 0.6, -0.1);
    plume.rotation.x = -0.3;
    headGroup.add(plume);

    headGroup.position.y = 2.7;
    this.mesh.add(headGroup);
    this.head = headGroup;

    // Pauldrons (Shoulders)
    const pLeft = new THREE.Mesh(new THREE.BoxGeometry(0.5, 0.4, 0.6), goldMat);
    pLeft.position.set(-0.85, 2.1, 0);
    this.mesh.add(pLeft);

    const pRight = new THREE.Mesh(new THREE.BoxGeometry(0.5, 0.4, 0.6), goldMat);
    pRight.position.set(0.85, 2.1, 0);
    this.mesh.add(pRight);

    // Arms
    this.armLeft = new THREE.Mesh(new THREE.BoxGeometry(0.35, 1.0, 0.35), armorMat);
    this.armLeft.position.set(-0.8, 1.5, 0);
    this.mesh.add(this.armLeft);

    this.armRight = new THREE.Mesh(new THREE.BoxGeometry(0.35, 1.0, 0.35), armorMat);
    this.armRight.position.set(0.8, 1.5, 0);
    this.mesh.add(this.armRight);

    // Shield on Left Arm
    const shieldMat = new THREE.MeshStandardMaterial({ color: 0x1e3a8a, metalness: 0.6, roughness: 0.4 });
    const shield = new THREE.Mesh(new THREE.BoxGeometry(0.1, 1.1, 0.8), shieldMat);
    shield.position.set(-1.05, 1.5, 0.2);
    this.mesh.add(shield);

    // Legs
    this.legLeft = new THREE.Mesh(new THREE.BoxGeometry(0.4, 1.0, 0.4), armorMat);
    this.legLeft.position.set(-0.35, 0.5, 0);
    this.mesh.add(this.legLeft);

    this.legRight = new THREE.Mesh(new THREE.BoxGeometry(0.4, 1.0, 0.4), armorMat);
    this.legRight.position.set(0.35, 0.5, 0);
    this.mesh.add(this.legRight);

    // Flowing Cape (Multi-segmented for cloth wave)
    this.cape = new THREE.Mesh(new THREE.PlaneGeometry(1.0, 1.8, 4, 6), capeMat);
    this.cape.position.set(0, 1.4, -0.45);
    this.cape.rotation.y = Math.PI;
    this.cape.castShadow = true;
    this.mesh.add(this.cape);
  }

  update(delta, inputDir, isSprinting, isJumpPressed) {
    // Horizontal Movement
    const speed = this.moveSpeed * (isSprinting ? this.sprintMultiplier : 1.0);
    const isMoving = inputDir.lengthSq() > 0.01;

    if (isMoving) {
      inputDir.normalize();
      this.velocity.x = inputDir.x * speed;
      this.velocity.z = inputDir.z * speed;

      // Smooth face angle rotation
      const targetAngle = Math.atan2(inputDir.x, inputDir.z);
      // Shortest angle lerp
      let diff = targetAngle - this.mesh.rotation.y;
      while (diff < -Math.PI) diff += Math.PI * 2;
      while (diff > Math.PI) diff -= Math.PI * 2;
      this.mesh.rotation.y += diff * 12.0 * delta;

      // Walking animation limbs swing
      this.walkCycle += delta * (isSprinting ? 14 : 9);
      const swing = Math.sin(this.walkCycle) * 0.45;
      this.legLeft.position.z = swing * 0.4;
      this.legRight.position.z = -swing * 0.4;
      this.armLeft.rotation.x = -swing * 0.6;
      this.armRight.rotation.x = swing * 0.6;

      // Cape wave flapping physics
      this.cape.rotation.x = 0.2 + (isSprinting ? 0.6 : 0.35) + Math.sin(this.walkCycle * 2) * 0.12;

      // Footsteps audio
      if (Math.sin(this.walkCycle) > 0.95 && this.isGrounded) {
        window.audioManager.playStep();
      }
    } else {
      this.velocity.x *= 0.75;
      this.velocity.z *= 0.75;
      this.legLeft.position.z = 0;
      this.legRight.position.z = 0;
      this.armLeft.rotation.x = 0;
      this.armRight.rotation.x = 0;
      this.cape.rotation.x = 0.15;
    }

    // Jump & Gravity Physics
    if (isJumpPressed && this.isGrounded) {
      this.velocity.y = this.jumpForce;
      this.isGrounded = false;
      window.audioManager.playJump();
    }

    if (!this.isGrounded) {
      this.velocity.y -= this.gravity * delta;
    }

    // Apply Position
    this.mesh.position.x += this.velocity.x * delta;
    this.mesh.position.y += this.velocity.y * delta;
    this.mesh.position.z += this.velocity.z * delta;

    // Ground Plane Collision at y = 0
    if (this.mesh.position.y <= 0) {
      this.mesh.position.y = 0;
      this.velocity.y = 0;
      this.isGrounded = true;
    }

    // Boundaries Clamp (Keep inside road & zones)
    this.mesh.position.x = Math.max(-45, Math.min(45, this.mesh.position.x));
    this.mesh.position.z = Math.max(-12, Math.min(235, this.mesh.position.z));
  }

  getPosition() {
    return this.mesh.position;
  }
}

window.Character = Character;
