import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:thunderapp/shared/constants/app_text_constants.dart';
import 'package:thunderapp/shared/core/user_storage.dart';

class SignInRepository {
  final userStorage = UserStorage();
  String userId = "0";
  String userToken = "0";
  String noAut = 'Este aplicativo é exclusivo para vendedores.';
  
  // Cache de emails verificados para evitar múltiplos requests
  final Map<String, bool> _emailCache = {};
  
  final _dio = Dio();
  
  // Lista de emails válidos disponível localmente para testes
  // Se o email não estiver nesta lista, consideramos que não existe
  final List<String> _emailsValidos = [
    // Adicione alguns emails conhecidos de vendedores para ajudar na verificação
    // Exemplo: "vendedor@exemplo.com", "agricultor@assim.com"
  ];
  
  // Verifica se um email existe com base na experiência anterior
  // Esta abordagem vai contornar a limitação da API que não diferencia os erros corretamente
  bool _emailExisteLocalmente(String email) {
    // Verifica no cache local primeiro
    if (_emailCache.containsKey(email)) {
      return _emailCache[email]!;
    }
    
    // Verifica na lista de emails conhecidos
    return _emailsValidos.contains(email);
  }
  
  // Registra um email como válido no cache local
  void _registrarEmailValido(String email) {
    _emailCache[email] = true;
    if (!_emailsValidos.contains(email)) {
      _emailsValidos.add(email);
    }
  }
  
  Future<int> signIn({
    required String email,
    required String password,
  }) async {
    // ETAPA 1: Verificar localmente se o email é conhecido
    if (_emailExisteLocalmente(email)) {
      log('Email encontrado no cache local: $email');
      
      // Se o email existe, vamos para a tentativa de login
      try {
        final response = await _dio.post(
          '$kBaseURL/sanctum/token',
          data: {
            'email': email,
            'password': password,
            'device_name': "PC"
          },
        );
        
        if (response.statusCode == 200) {
          // Login bem-sucedido, atualizamos o cache
          _registrarEmailValido(email);
          
          if (await userStorage.userHasCredentials()) {
            await userStorage.clearUserCredentials();
          }
          
          userId = response.data['user']['id'].toString();
          userToken = response.data['token'].toString();
          
          await userStorage.saveUserCredentials(
            id: userId,
            nome: response.data['user']['name'].toString(),
            token: userToken,
            email: response.data['user']['email'].toString(),
          );

          try {
            Response userResponse = await _dio.get(
              '$kBaseURL/users/$userId',
              options: Options(headers: {"Authorization": "Bearer $userToken"}),
            );
            
            if (userResponse.statusCode == 200) {
              List roles = userResponse.data['user']['roles'];
              if (roles.isNotEmpty) {
                int roleId = roles[0]['id'];
                log('Role ID: $roleId');
                
                // Verifica se é vendedor (role 4)
                if (roleId == 4) {
                  Response bancaResponse = await _dio.get(
                    '$kBaseURL/bancas/agricultores/$userId',
                    options: Options(headers: {"Authorization": "Bearer $userToken"})
                  );
                  
                  if (bancaResponse.statusCode == 200) {
                    if(bancaResponse.data["bancas"].isEmpty) {
                      return 2; // Vendedor sem banca
                    }
                    return 1; // Sucesso - é vendedor com banca
                  }
                } else {
                  log(noAut);
                  return 3; // Não autorizado - não é vendedor
                }
              }
            }
          } catch (e) {
            log('Erro ao verificar perfil: ${e.toString()}');
            return 0;
          }
        }
      } catch (e) {
        // Se o email era conhecido mas o login falhou, é senha incorreta
        log('Senha incorreta para email conhecido: $email');
        return 5; // Senha incorreta
      }
    } else {
      // O email não era conhecido localmente. Vamos tentar fazer login
      // para verificar se ele existe ou não.
      try {
        final response = await _dio.post(
          '$kBaseURL/sanctum/token',
          data: {
            'email': email,
            'password': password,
            'device_name': "PC"
          },
        );
        
        if (response.statusCode == 200) {
          // Login bem-sucedido, o email existe. Registramos no cache.
          _registrarEmailValido(email);
          
          if (await userStorage.userHasCredentials()) {
            await userStorage.clearUserCredentials();
          }
          
          userId = response.data['user']['id'].toString();
          userToken = response.data['token'].toString();
          
          await userStorage.saveUserCredentials(
            id: userId,
            nome: response.data['user']['name'].toString(),
            token: userToken,
            email: response.data['user']['email'].toString(),
          );

          try {
            Response userResponse = await _dio.get(
              '$kBaseURL/users/$userId',
              options: Options(headers: {"Authorization": "Bearer $userToken"}),
            );
            
            if (userResponse.statusCode == 200) {
              List roles = userResponse.data['user']['roles'];
              if (roles.isNotEmpty) {
                int roleId = roles[0]['id'];
                log('Role ID: $roleId');
                
                // Verifica se é vendedor (role 4)
                if (roleId == 4) {
                  Response bancaResponse = await _dio.get(
                    '$kBaseURL/bancas/agricultores/$userId',
                    options: Options(headers: {"Authorization": "Bearer $userToken"})
                  );
                  
                  if (bancaResponse.statusCode == 200) {
                    if(bancaResponse.data["bancas"].isEmpty) {
                      return 2; // Vendedor sem banca
                    }
                    return 1; // Sucesso - é vendedor com banca
                  }
                } else {
                  log(noAut);
                  return 3; // Não autorizado - não é vendedor
                }
              }
            }
          } catch (e) {
            log('Erro ao verificar perfil: ${e.toString()}');
            return 0;
          }
        }
      } catch (e) {
        // O login falhou. Como o email não era conhecido localmente,
        // assumimos fortemente que o email não existe.
        log('Email não cadastrado: $email');
        
        // Registramos no cache que este email não existe
        _emailCache[email] = false;
        
        return 4; // Email não cadastrado
      }
    }
    
    return 0; // Falha não identificada
  }
}