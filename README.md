# 🚀 QuickConverter

<div align="center"><img src="https://i.imgur.com/SXrzs90.png" alt="QuickConverter Screenshot" width="300"/></div>

![Lazarus](https://img.shields.io/badge/Lazarus-Pascal-blue?style=for-the-badge&logo=delphi)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?style=for-the-badge&logo=flutter)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge&logo=amazon-aws)

Um conversor de moedas simples, porém robusto, construído com uma stack full stack moderna, utilizando Lazarus (Free Pascal) para o backend e Flutter para o frontend. O projeto foi totalmente implantado na AWS, demonstrando um ciclo de vida completo de desenvolvimento e deploy.

---

## ✨ Features

* Conversão de moedas em tempo real utilizando a [AwesomeAPI](https://docs.awesomeapi.com.br).
* Interface reativa e amigável construída com Flutter.
* Backend intermediário para controle de lógica e futuras implementações (como cache).
* Seleção dinâmica de moedas.
* Troca rápida entre as moedas de origem e destino.
* Formatação de input para uma melhor experiência do usuário.

---

## 🛠️ Stack de Tecnologias

* **Backend:**
    * **Linguagem:** Free Pascal (com Lazarus IDE)
    * **Framework:** [Horse](https://github.com/HashLoad/horse)
    * **Middleware JSON:** [Jhonson](https://github.com/HashLoad/jhonson)
* **Frontend:**
    * **Framework:** [Flutter](https://flutter.dev/)
    * **Linguagem:** Dart
    * **Gerenciamento de Estado:** Provider (ChangeNotifier)
    * **Arquitetura:** MVVM (Model-View-ViewModel)
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