# 🚀 QuickConverter (v2.0)

<div align="center"><img src="https://i.imgur.com/SXrzs90.png" alt="QuickConverter Screenshot" width="300"/>

![Lazarus](https://img.shields.io/badge/Lazarus-Pascal-blue?style=for-the-badge&logo=delphi)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?style=for-the-badge&logo=flutter)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge&logo=amazon-aws)


Conversor de moedas full stack robusto e performático, construído com **Lazarus (Free Pascal)** para o backend e **Flutter** para o frontend. O projeto demonstra um ciclo de vida completo de desenvolvimento, incluindo cache no servidor, temas customizáveis e implantação na nuvem AWS.
</div>

---

## ✨ Features

* **Cache no Servidor (Lazarus):** O backend armazena cotações em cache para reduzir drasticamente a latência e evitar bloqueios por excesso de requisições (`Erro 429`) da API externa.
* **Temas Customizáveis:** Seletor de paleta de cores (Azul, Vermelho, Amarelo e Verde) com gerenciamento de estado via Provider, permitindo total personalização da UI.
* **Interface Reativa (Flutter):** UI moderna com `Sidebar` para navegação, `Dropdowns` dinâmicos e formatação de input em tempo real para uma experiência de usuário fluida.
* **Troca Rápida (Swap):** Funcionalidade para inverter moedas e valores entre os campos "From" e "To" com um único toque.
* **Deploy na AWS:** Aplicação completa implantada em um servidor EC2, acessível publicamente.

---

## 🛠️ Stack de Tecnologias

* **Backend:**
    * **Linguagem:** Free Pascal (com Lazarus IDE)
    * **Framework:** [Horse](https://github.com/HashLoad/horse)
    * **Middleware JSON:** [Jhonson](https://github.com/HashLoad/jhonson)
* **Frontend:**
    * **Framework:** [Flutter](https://flutter.dev/)
    * **Linguagem:** Dart
    * **Gerenciamento de Estado:** Provider (`ChangeNotifier`)
    * **Arquitetura:** MVVM aprimorada (com camada de `Repository`)
* **Infraestrutura (Deploy):**
    * **Cloud:** [Amazon Web Services (AWS)](https://aws.amazon.com/)
    * **Serviço:** EC2 (Windows Server 2019)

---

## ⚙️ Como Executar Localmente

### Pré-requisitos

* [Lazarus IDE](https://www.lazarus-ide.org/) instalado.
* [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
* DLLs do OpenSSL (`libeay32.dll` e `ssleay32.dll`) na pasta do backend.
* Biblioteca [Jhonson](https://github.com/HashLoad/jhonson) configurada no projeto Lazarus.

### 1. Backend (Lazarus)

1.  Abra o arquivo `backend/backend.lpi` no Lazarus IDE.
2.  Compile e execute o projeto (`F9`). O servidor iniciará na porta `9000`.

### 2. Frontend (Flutter)

1.  Navegue até a pasta `frontend/`.
2.  **Crie um arquivo chamado `.env`** na raiz da pasta `frontend/`.
3.  Adicione a seguinte linha ao arquivo `.env` para apontar para o seu servidor local:
    ```
    API_URL=http://localhost:9000
    ```
4.  Execute o app em um emulador, navegador ou dispositivo físico:
    ```bash
    flutter run
    ```

---

## ☁️ Informações do Deploy (AWS)

A API está hospedada em uma instância EC2 da AWS. Para que o aplicativo Flutter se comunique com o servidor na nuvem, o arquivo `.env` deve ser configurado com o IP público da instância:

```
# Exemplo de conteúdo do arquivo .env para produção
API_URL=http://SEU_IP_PUBLICO_DA_AWS:9000
```
**Nota:** O arquivo `.env` está listado no `.gitignore` e não deve ser versionado, garantindo que as configurações de produção não sejam expostas no repositório.

---

## 👤 Autor

**Gabriel Rodrigues**

Desenvolvedor Full Stack (Lazarus + Flutter)