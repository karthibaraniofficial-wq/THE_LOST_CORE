import os

SCENES_DIR = r"E:\funobotz\game\scenes\funobotz"
PROPS_DIR = r"E:\funobotz\game\scenes\world\environment\props"
os.makedirs(SCENES_DIR, exist_ok=True)
os.makedirs(PROPS_DIR, exist_ok=True)

# -----------------------------------------------------------------------------
# 1. PETALO.TSCN
# -----------------------------------------------------------------------------
petalo_content = """[gd_scene load_steps=18 format=3 uid="uid://funobotz_petalo001"]

[ext_resource type="Script" path="res://scripts/funobotz/petalo.gd" id="1_petalo"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/funobotz_logo.png" id="2_logo"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/petalo_face.png" id="3_face"]

[sub_resource type="CylinderShape3D" id="CylinderShape3D_root"]
height = 1.15
radius = 0.42

[sub_resource type="SphereShape3D" id="SphereShape3D_interact"]
radius = 2.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_white"]
albedo_color = Color(0.96, 0.96, 0.95, 1)
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_logo"]
albedo_texture = ExtResource("2_logo")
roughness = 0.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_green"]
albedo_color = Color(0.35, 0.72, 0.25, 1)
roughness = 0.45

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_face"]
albedo_texture = ExtResource("3_face")
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_petal"]
albedo_color = Color(0.98, 0.78, 0.12, 1)
roughness = 0.3
emission_enabled = true
emission = Color(0.95, 0.65, 0.05, 1)
emission_energy_multiplier = 0.25

[sub_resource type="CylinderMesh" id="CylinderMesh_pedestal"]
material = SubResource("StandardMaterial3D_white")
top_radius = 0.32
bottom_radius = 0.38
height = 0.24
radial_segments = 8

[sub_resource type="BoxMesh" id="BoxMesh_brand"]
material = SubResource("StandardMaterial3D_logo")
size = Vector3(0.36, 0.16, 0.04)

[sub_resource type="CylinderMesh" id="CylinderMesh_neck"]
material = SubResource("StandardMaterial3D_green")
top_radius = 0.08
bottom_radius = 0.09
height = 0.22

[sub_resource type="CylinderMesh" id="CylinderMesh_head_center"]
material = SubResource("StandardMaterial3D_face")
top_radius = 0.26
bottom_radius = 0.26
height = 0.08
radial_segments = 16

[sub_resource type="SphereMesh" id="SphereMesh_petal"]
material = SubResource("StandardMaterial3D_petal")
radius = 0.09
height = 0.22

[sub_resource type="Animation" id="Animation_idle"]
resource_name = "idle"
length = 2.4
loop_mode = 1
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model/Head:rotation")
tracks/0/interp = 2
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.6, 1.2, 1.8, 2.4),
"transitions": PackedFloat32Array(1, 1, 1, 1, 1),
"update": 0,
"values": [Vector3(0, 0, 0), Vector3(0, 0, 0.06), Vector3(0, 0, 0), Vector3(0, 0, -0.06), Vector3(0, 0, 0)]
}
tracks/1/type = "value"
tracks/1/imported = false
tracks/1/enabled = true
tracks/1/path = NodePath("PointLight3D:light_energy")
tracks/1/interp = 2
tracks/1/loop_wrap = true
tracks/1/keys = {
"times": PackedFloat32Array(0, 1.2, 2.4),
"transitions": PackedFloat32Array(1, 1, 1),
"update": 0,
"values": [1.8, 2.4, 1.8]
}

[sub_resource type="Animation" id="Animation_ability"]
resource_name = "ability"
length = 1.0
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model/Head:rotation")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.5, 1),
"transitions": PackedFloat32Array(1, 1, 1),
"update": 0,
"values": [Vector3(0, 0, 0), Vector3(0, 3.14159, 0), Vector3(0, 6.28318, 0)]
}

[sub_resource type="AnimationLibrary" id="AnimationLibrary_petalo"]
_data = {
"ability": SubResource("Animation_ability"),
"idle": SubResource("Animation_idle")
}

[node name="Petalo" type="CharacterBody3D"]
collision_layer = 1
collision_mask = 3
script = ExtResource("1_petalo")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.58, 0)
shape = SubResource("CylinderShape3D_root")

[node name="InteractionArea" type="Area3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.5, 0)
collision_layer = 4
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="InteractionArea"]
shape = SubResource("SphereShape3D_interact")

[node name="PointLight3D" type="OmniLight3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.85, -0.15)
light_color = Color(1, 0.92, 0.55, 1)
light_energy = 2.0
omni_range = 10.0
shadow_enabled = true

[node name="AudioStreamPlayer3D" type="AudioStreamPlayer3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.8, 0)

[node name="AnimationPlayer" type="AnimationPlayer" parent="."]
libraries = {
"": SubResource("AnimationLibrary_petalo")
}
autoplay = "idle"

[node name="Model" type="Node3D" parent="."]

[node name="Pedestal" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.12, 0)
mesh = SubResource("CylinderMesh_pedestal")

[node name="BrandPlate" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.12, -0.32)
mesh = SubResource("BoxMesh_brand")

[node name="Neck" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.35, 0)
mesh = SubResource("CylinderMesh_neck")

[node name="Head" type="Node3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.78, 0)

[node name="FaceCenter" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(1, 0, 0, 0, -4.37114e-08, -1, 0, 1, -4.37114e-08, 0, 0, -0.04)
mesh = SubResource("CylinderMesh_head_center")

[node name="Petal1" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.32, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal2" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.866025, -0.5, 0, 0.5, 0.866025, 0, 0, 0, 1, 0.16, 0.28, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal3" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.5, -0.866025, 0, 0.866025, 0.5, 0, 0, 0, 1, 0.28, 0.16, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal4" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0, -1, 0, 1, 0, 0, 0, 0, 1, 0.32, 0, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal5" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.5, 0.866025, 0, -0.866025, 0.5, 0, 0, 0, 1, 0.28, -0.16, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal6" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.866025, 0.5, 0, -0.5, 0.866025, 0, 0, 0, 1, 0.16, -0.28, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal7" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.32, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal8" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.866025, -0.5, 0, 0.5, 0.866025, 0, 0, 0, 1, -0.16, -0.28, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal9" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.5, -0.866025, 0, 0.866025, 0.5, 0, 0, 0, 1, -0.28, -0.16, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal10" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0, -1, 0, 1, 0, 0, 0, 0, 1, -0.32, 0, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal11" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.5, 0.866025, 0, -0.866025, 0.5, 0, 0, 0, 1, -0.28, 0.16, 0)
mesh = SubResource("SphereMesh_petal")

[node name="Petal12" type="MeshInstance3D" parent="Model/Head"]
transform = Transform3D(0.866025, 0.5, 0, -0.5, 0.866025, 0, 0, 0, 1, -0.16, 0.28, 0)
mesh = SubResource("SphereMesh_petal")
"""

with open(os.path.join(SCENES_DIR, "Petalo.tscn"), "w", encoding="utf-8") as f:
    f.write(petalo_content)
print("Saved Petalo.tscn")

# -----------------------------------------------------------------------------
# 2. QUACKY.TSCN
# -----------------------------------------------------------------------------
quacky_content = """[gd_scene load_steps=17 format=3 uid="uid://funobotz_quacky001"]

[ext_resource type="Script" path="res://scripts/funobotz/quacky.gd" id="1_quacky"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/funobotz_logo.png" id="2_logo"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/quacky_face.png" id="3_face"]

[sub_resource type="BoxShape3D" id="BoxShape3D_root"]
size = Vector3(0.75, 0.65, 0.95)

[sub_resource type="SphereShape3D" id="SphereShape3D_interact"]
radius = 2.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_white"]
albedo_color = Color(0.96, 0.96, 0.95, 1)
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_logo"]
albedo_texture = ExtResource("2_logo")
roughness = 0.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_head"]
albedo_texture = ExtResource("3_face")
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_red"]
albedo_color = Color(0.92, 0.22, 0.18, 1)
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_green"]
albedo_color = Color(0.22, 0.78, 0.25, 1)
roughness = 0.35

[sub_resource type="BoxMesh" id="BoxMesh_body"]
material = SubResource("StandardMaterial3D_white")
size = Vector3(0.68, 0.28, 0.82)

[sub_resource type="BoxMesh" id="BoxMesh_brand"]
material = SubResource("StandardMaterial3D_logo")
size = Vector3(0.36, 0.16, 0.04)

[sub_resource type="PrismMesh" id="PrismMesh_head"]
material = SubResource("StandardMaterial3D_head")
left_to_right = 0.5
size = Vector3(0.42, 0.38, 0.48)

[sub_resource type="SphereMesh" id="SphereMesh_joint"]
material = SubResource("StandardMaterial3D_red")
radius = 0.08
height = 0.16

[sub_resource type="SphereMesh" id="SphereMesh_wheel"]
material = SubResource("StandardMaterial3D_green")
radius = 0.09
height = 0.18

[sub_resource type="Animation" id="Animation_idle"]
resource_name = "idle"
length = 2.0
loop_mode = 1
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model/HeadRoot:rotation")
tracks/0/interp = 2
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.5, 1.0, 1.5, 2.0),
"transitions": PackedFloat32Array(1, 1, 1, 1, 1),
"update": 0,
"values": [Vector3(0, 0, 0), Vector3(0.08, 0.1, 0), Vector3(0, 0, 0), Vector3(0.08, -0.1, 0), Vector3(0, 0, 0)]
}

[sub_resource type="Animation" id="Animation_ability"]
resource_name = "ability"
length = 0.8
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model:rotation")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.2, 0.4, 0.6, 0.8),
"transitions": PackedFloat32Array(1, 1, 1, 1, 1),
"update": 0,
"values": [Vector3(0, 0, 0), Vector3(0, 0, 0.12), Vector3(0, 0, -0.12), Vector3(0, 0, 0.12), Vector3(0, 0, 0)]
}

[sub_resource type="AnimationLibrary" id="AnimationLibrary_quacky"]
_data = {
"ability": SubResource("Animation_ability"),
"idle": SubResource("Animation_idle")
}

[node name="Quacky" type="CharacterBody3D"]
collision_layer = 1
collision_mask = 3
script = ExtResource("1_quacky")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.35, 0)
shape = SubResource("BoxShape3D_root")

[node name="InteractionArea" type="Area3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.35, 0)
collision_layer = 4
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="InteractionArea"]
shape = SubResource("SphereShape3D_interact")

[node name="AudioStreamPlayer3D" type="AudioStreamPlayer3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.5, 0)

[node name="AnimationPlayer" type="AnimationPlayer" parent="."]
libraries = {
"": SubResource("AnimationLibrary_quacky")
}
autoplay = "idle"

[node name="Model" type="Node3D" parent="."]

[node name="Body" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.22, 0)
mesh = SubResource("BoxMesh_body")

[node name="BrandPlateL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.22, -0.42)
mesh = SubResource("BoxMesh_brand")

[node name="HeadRoot" type="Node3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 0.965926, 0.258819, 0, -0.258819, 0.965926, 0, 0.44, -0.25)

[node name="HeadMesh" type="MeshInstance3D" parent="Model/HeadRoot"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.12, 0)
mesh = SubResource("PrismMesh_head")

[node name="LegFL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.38, 0.12, -0.3)
mesh = SubResource("SphereMesh_joint")

[node name="WheelFL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.46, 0.1, -0.3)
mesh = SubResource("SphereMesh_wheel")

[node name="LegFR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.38, 0.12, -0.3)
mesh = SubResource("SphereMesh_joint")

[node name="WheelFR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.46, 0.1, -0.3)
mesh = SubResource("SphereMesh_wheel")

[node name="LegRL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.38, 0.12, 0.3)
mesh = SubResource("SphereMesh_wheel")

[node name="WheelRL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.46, 0.1, 0.3)
mesh = SubResource("SphereMesh_joint")

[node name="LegRR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.38, 0.12, 0.3)
mesh = SubResource("SphereMesh_wheel")

[node name="WheelRR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.46, 0.1, 0.3)
mesh = SubResource("SphereMesh_joint")
"""

with open(os.path.join(SCENES_DIR, "Quacky.tscn"), "w", encoding="utf-8") as f:
    f.write(quacky_content)
print("Saved Quacky.tscn")

# -----------------------------------------------------------------------------
# 3. TOLLY.TSCN
# -----------------------------------------------------------------------------
tolly_content = """[gd_scene load_steps=18 format=3 uid="uid://funobotz_tolly001"]

[ext_resource type="Script" path="res://scripts/funobotz/tolly.gd" id="1_tolly"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/funobotz_logo.png" id="2_logo"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/tolly_face.png" id="3_face"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/tolly_lights.png" id="4_lights"]

[sub_resource type="BoxShape3D" id="BoxShape3D_root"]
size = Vector3(0.68, 1.35, 0.68)

[sub_resource type="SphereShape3D" id="SphereShape3D_interact"]
radius = 2.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_white"]
albedo_color = Color(0.96, 0.96, 0.95, 1)
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_logo"]
albedo_texture = ExtResource("2_logo")
roughness = 0.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_face"]
albedo_texture = ExtResource("3_face")
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_lights"]
albedo_texture = ExtResource("4_lights")
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_arm"]
albedo_color = Color(0.95, 0.55, 0.15, 1)
roughness = 0.35

[sub_resource type="BoxMesh" id="BoxMesh_base"]
material = SubResource("StandardMaterial3D_white")
size = Vector3(0.64, 0.22, 0.64)

[sub_resource type="BoxMesh" id="BoxMesh_brand"]
material = SubResource("StandardMaterial3D_logo")
size = Vector3(0.36, 0.14, 0.04)

[sub_resource type="BoxMesh" id="BoxMesh_torso"]
material = SubResource("StandardMaterial3D_face")
size = Vector3(0.52, 0.62, 0.52)

[sub_resource type="BoxMesh" id="BoxMesh_head"]
material = SubResource("StandardMaterial3D_lights")
size = Vector3(0.32, 0.32, 0.32)

[sub_resource type="BoxMesh" id="BoxMesh_arm"]
material = SubResource("StandardMaterial3D_arm")
size = Vector3(0.55, 0.12, 0.12)

[sub_resource type="Animation" id="Animation_idle"]
resource_name = "idle"
length = 2.0
loop_mode = 1
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model/Head:position")
tracks/0/interp = 2
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 1.0, 2.0),
"transitions": PackedFloat32Array(1, 1, 1),
"update": 0,
"values": [Vector3(0, 0.98, 0), Vector3(0, 1.02, 0), Vector3(0, 0.98, 0)]
}

[sub_resource type="Animation" id="Animation_ability"]
resource_name = "ability"
length = 0.8
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model/Arm:rotation")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.4, 0.8),
"transitions": PackedFloat32Array(1, 1, 1),
"update": 0,
"values": [Vector3(0, 0, 0), Vector3(0, 0, -1.48353), Vector3(0, 0, 0)]
}

[sub_resource type="AnimationLibrary" id="AnimationLibrary_tolly"]
_data = {
"ability": SubResource("Animation_ability"),
"idle": SubResource("Animation_idle")
}

[node name="Tolly" type="CharacterBody3D"]
collision_layer = 1
collision_mask = 3
script = ExtResource("1_tolly")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.68, 0)
shape = SubResource("BoxShape3D_root")

[node name="InteractionArea" type="Area3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.6, 0)
collision_layer = 4
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="InteractionArea"]
shape = SubResource("SphereShape3D_interact")

[node name="AudioStreamPlayer3D" type="AudioStreamPlayer3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.8, 0)

[node name="AnimationPlayer" type="AnimationPlayer" parent="."]
libraries = {
"": SubResource("AnimationLibrary_tolly")
}
autoplay = "idle"

[node name="Model" type="Node3D" parent="."]

[node name="Base" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.11, 0)
mesh = SubResource("BoxMesh_base")

[node name="BrandPlate" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.11, -0.33)
mesh = SubResource("BoxMesh_brand")

[node name="Torso" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.53, 0)
mesh = SubResource("BoxMesh_torso")

[node name="Head" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.98, 0)
mesh = SubResource("BoxMesh_head")

[node name="Arm" type="Node3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.26, 0.55, 0)

[node name="ArmMesh" type="MeshInstance3D" parent="Model/Arm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.28, 0, 0)
mesh = SubResource("BoxMesh_arm")
"""

with open(os.path.join(SCENES_DIR, "Tolly.tscn"), "w", encoding="utf-8") as f:
    f.write(tolly_content)
print("Saved Tolly.tscn")

# -----------------------------------------------------------------------------
# 4. TIKO.TSCN
# -----------------------------------------------------------------------------
tiko_content = """[gd_scene load_steps=18 format=3 uid="uid://funobotz_tiko001"]

[ext_resource type="Script" path="res://scripts/funobotz/tiko.gd" id="1_tiko"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/funobotz_logo.png" id="2_logo"]
[ext_resource type="Texture2D" path="res://assets/textures/funobotz/tiko_truss.png" id="3_truss"]

[sub_resource type="BoxShape3D" id="BoxShape3D_root"]
size = Vector3(0.55, 0.75, 1.45)

[sub_resource type="SphereShape3D" id="SphereShape3D_interact"]
radius = 2.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_white"]
albedo_color = Color(0.96, 0.96, 0.95, 1)
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_logo"]
albedo_texture = ExtResource("2_logo")
roughness = 0.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_truss"]
albedo_texture = ExtResource("3_truss")
roughness = 0.35

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_spring"]
albedo_color = Color(0.92, 0.72, 0.25, 1)
metallic = 0.85
roughness = 0.25

[sub_resource type="BoxMesh" id="BoxMesh_body"]
material = SubResource("StandardMaterial3D_truss")
size = Vector3(0.48, 0.36, 0.82)

[sub_resource type="BoxMesh" id="BoxMesh_brand"]
material = SubResource("StandardMaterial3D_logo")
size = Vector3(0.34, 0.16, 0.04)

[sub_resource type="BoxMesh" id="BoxMesh_truss_arm"]
material = SubResource("StandardMaterial3D_truss")
size = Vector3(0.26, 0.20, 1.25)

[sub_resource type="CylinderMesh" id="CylinderMesh_spring"]
material = SubResource("StandardMaterial3D_spring")
top_radius = 0.08
bottom_radius = 0.08
height = 0.18
radial_segments = 8

[sub_resource type="CylinderMesh" id="CylinderMesh_antenna"]
material = SubResource("StandardMaterial3D_spring")
top_radius = 0.015
bottom_radius = 0.02
height = 0.32

[sub_resource type="Animation" id="Animation_idle"]
resource_name = "idle"
length = 2.0
loop_mode = 1
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model:position")
tracks/0/interp = 2
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 1.0, 2.0),
"transitions": PackedFloat32Array(1, 1, 1),
"update": 0,
"values": [Vector3(0, 0, 0), Vector3(0, 0.04, 0), Vector3(0, 0, 0)]
}

[sub_resource type="Animation" id="Animation_ability"]
resource_name = "ability"
length = 0.8
tracks/0/type = "value"
tracks/0/imported = false
tracks/0/enabled = true
tracks/0/path = NodePath("Model/TrussArm:rotation")
tracks/0/interp = 1
tracks/0/loop_wrap = true
tracks/0/keys = {
"times": PackedFloat32Array(0, 0.4, 0.8),
"transitions": PackedFloat32Array(1, 1, 1),
"update": 0,
"values": [Vector3(-0.261799, 0, 0), Vector3(-0.698132, 0, 0), Vector3(-0.261799, 0, 0)]
}

[sub_resource type="AnimationLibrary" id="AnimationLibrary_tiko"]
_data = {
"ability": SubResource("Animation_ability"),
"idle": SubResource("Animation_idle")
}

[node name="Tiko" type="CharacterBody3D"]
collision_layer = 1
collision_mask = 3
script = ExtResource("1_tiko")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.45, 0)
shape = SubResource("BoxShape3D_root")

[node name="InteractionArea" type="Area3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.45, 0)
collision_layer = 4
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="InteractionArea"]
shape = SubResource("SphereShape3D_interact")

[node name="AudioStreamPlayer3D" type="AudioStreamPlayer3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.5, 0)

[node name="AnimationPlayer" type="AnimationPlayer" parent="."]
libraries = {
"": SubResource("AnimationLibrary_tiko")
}
autoplay = "idle"

[node name="Model" type="Node3D" parent="."]

[node name="Body" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.32, -0.15)
mesh = SubResource("BoxMesh_body")

[node name="BrandPlate" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.32, -0.57)
mesh = SubResource("BoxMesh_brand")

[node name="TrussArm" type="Node3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 0.965926, -0.258819, 0, 0.258819, 0.965926, 0, 0.38, 0.15)

[node name="ArmMesh" type="MeshInstance3D" parent="Model/TrussArm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0.6)
mesh = SubResource("BoxMesh_truss_arm")

[node name="SpringFL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.22, 0.09, -0.4)
mesh = SubResource("CylinderMesh_spring")

[node name="SpringFR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.22, 0.09, -0.4)
mesh = SubResource("CylinderMesh_spring")

[node name="SpringRL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.22, 0.09, 0.1)
mesh = SubResource("CylinderMesh_spring")

[node name="SpringRR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.22, 0.09, 0.1)
mesh = SubResource("CylinderMesh_spring")

[node name="AntennaL" type="MeshInstance3D" parent="Model"]
transform = Transform3D(0.965926, 0.258819, 0, -0.258819, 0.965926, 0, 0, 0, 1, -0.15, 0.62, -0.3)
mesh = SubResource("CylinderMesh_antenna")

[node name="AntennaR" type="MeshInstance3D" parent="Model"]
transform = Transform3D(0.965926, -0.258819, 0, 0.258819, 0.965926, 0, 0, 0, 1, 0.15, 0.62, -0.3)
mesh = SubResource("CylinderMesh_antenna")
"""

with open(os.path.join(SCENES_DIR, "Tiko.tscn"), "w", encoding="utf-8") as f:
    f.write(tiko_content)
print("Saved Tiko.tscn")

# -----------------------------------------------------------------------------
# 5. FUNOBOTZ_HUB.TSCN
# -----------------------------------------------------------------------------
hub_content = """[gd_scene load_steps=13 format=3 uid="uid://funobotzhub001"]

[ext_resource type="PackedScene" path="res://scenes/funobotz/Petalo.tscn" id="1_petalo"]
[ext_resource type="PackedScene" path="res://scenes/funobotz/Quacky.tscn" id="2_quacky"]
[ext_resource type="PackedScene" path="res://scenes/funobotz/Tolly.tscn" id="3_tolly"]
[ext_resource type="PackedScene" path="res://scenes/funobotz/Tiko.tscn" id="4_tiko"]
[ext_resource type="PackedScene" path="res://assets/models/pillar_decorated.gltf.glb" id="5_pillar"]
[ext_resource type="PackedScene" path="res://assets/models/torch_lit.gltf.glb" id="6_torch"]
[ext_resource type="PackedScene" path="res://assets/models/banner_shield_blue.gltf.glb" id="7_banner"]

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_dais"]
albedo_color = Color(0.55, 0.52, 0.46, 1)
roughness = 0.75

[sub_resource type="CylinderMesh" id="CylinderMesh_dais"]
material = SubResource("StandardMaterial3D_dais")
top_radius = 4.6
bottom_radius = 4.9
height = 0.14
radial_segments = 24

[sub_resource type="CylinderShape3D" id="CylinderShape3D_dais"]
height = 0.14
radius = 4.8

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_pedestal"]
albedo_color = Color(0.72, 0.68, 0.58, 1)
roughness = 0.6

[sub_resource type="CylinderMesh" id="CylinderMesh_pedestal"]
material = SubResource("StandardMaterial3D_pedestal")
top_radius = 0.55
bottom_radius = 0.65
height = 0.10
radial_segments = 12

[node name="FunobotzHub" type="StaticBody3D"]

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.07, 0)
shape = SubResource("CylinderShape3D_dais")

[node name="DaisMesh" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.07, 0)
mesh = SubResource("CylinderMesh_dais")

[node name="PillarL" parent="." instance=ExtResource("5_pillar")]
transform = Transform3D(1.1, 0, 0, 0, 1.3, 0, 0, 0, 1.1, -4.0, 0, -0.5)

[node name="PillarR" parent="." instance=ExtResource("5_pillar")]
transform = Transform3D(1.1, 0, 0, 0, 1.3, 0, 0, 0, 1.1, 4.0, 0, -0.5)

[node name="TorchL" parent="." instance=ExtResource("6_torch")]
transform = Transform3D(1.1, 0, 0, 0, 1.1, 0, 0, 0, 1.1, -4.0, 2.3, -0.5)

[node name="TorchR" parent="." instance=ExtResource("6_torch")]
transform = Transform3D(1.1, 0, 0, 0, 1.1, 0, 0, 0, 1.1, 4.0, 2.3, -0.5)

[node name="BannerL" parent="." instance=ExtResource("7_banner")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -4.0, 1.1, -0.1)

[node name="BannerR" parent="." instance=ExtResource("7_banner")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 4.0, 1.1, -0.1)

[node name="Pedestal1" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -2.8, 0.12, -0.2)
mesh = SubResource("CylinderMesh_pedestal")

[node name="Pedestal2" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.0, 0.12, -0.4)
mesh = SubResource("CylinderMesh_pedestal")

[node name="Pedestal3" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.0, 0.12, -0.4)
mesh = SubResource("CylinderMesh_pedestal")

[node name="Pedestal4" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 2.8, 0.12, -0.2)
mesh = SubResource("CylinderMesh_pedestal")

[node name="Petalo" parent="." instance=ExtResource("1_petalo")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -2.8, 0.17, -0.2)

[node name="Quacky" parent="." instance=ExtResource("2_quacky")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.0, 0.17, -0.4)

[node name="Tolly" parent="." instance=ExtResource("3_tolly")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.0, 0.17, -0.4)

[node name="Tiko" parent="." instance=ExtResource("4_tiko")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 2.8, 0.17, -0.2)
"""

with open(os.path.join(PROPS_DIR, "FunobotzHub.tscn"), "w", encoding="utf-8") as f:
    f.write(hub_content)
print("Saved FunobotzHub.tscn")
