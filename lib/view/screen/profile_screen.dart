import 'package:flutter/material.dart';
import 'package:chatpp/controller/auth_controller.dart';
import 'package:chatpp/controller/user_controller.dart';
import '../../model/app_user.dart';
import '../../controller/imgur_uploader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthController();
  final _userController = UserController();
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfileImage() async {
    final userId = _auth.getCurrentUser()?.uid;
    if (userId == null) return;

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final imageUrl = await ImgurUploader.pickAndUploadImageToImgur();
      if (imageUrl != null) {
        await _userController.updateUserProfileImage(imageUrl);
      }
    } catch (e) {
      debugPrint('Erro ao atualizar imagem: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao atualizar imagem')));
    } finally {
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _updateUserName() async {
    final userId = _auth.getCurrentUser()?.uid;
    if (userId == null || _nameController.text.isEmpty) return;

    try {
      await _userController.updateUserName(_nameController.text);
      setState(() => _isEditingName = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome atualizado com sucesso')),
      );
    } catch (e) {
      debugPrint('Erro ao atualizar nome: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao atualizar nome')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.getCurrentUser()?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não autenticado")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: StreamBuilder<AppUser>(
        stream: _userController.getUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar usuário'));
          }

          final user = snapshot.data!;
          _nameController = TextEditingController(text: user.name);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Área da foto de perfil
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: _updateProfileImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            user.profileImageUrl != null
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                        child:
                            user.profileImageUrl == null
                                ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Campo de nome editável
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _nameController,
                      enabled: _isEditingName,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isEditingName ? Icons.check : Icons.edit),
                      onPressed: () {
                        if (_isEditingName) {
                          if (_nameController.text != snapshot.data!.name) {
                            _updateUserName();
                          } else {
                            setState(() => _isEditingName = false);
                          }
                        } else {
                          setState(() => _isEditingName = true);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Campo de email com o mesmo tamanho do nome
                TextField(
                  controller: TextEditingController(text: user.email),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    enabled: false,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
