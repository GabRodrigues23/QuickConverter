# 🚀 QuickConverter (v3.0)

<div align="center">
<img src="https://i.imgur.com/Mb0gJ75.png" alt="QuickConverter Screen Blue" width="150"/> 
<img src="https://i.imgur.com/HbP0KJb.png" alt="QuickConverter Screen Red" width="150"/> 
<img src="https://i.imgur.com/VcOueFM.png" alt="QuickConverter Screen Yellow" width="150"/> 
<img src="https://i.imgur.com/ZAwhbrH.png" alt="QuickConverter Screen Green" width="150"/> 

![Lazarus](https://img.shields.io/badge/Lazarus-Pascal-blue?style=for-the-badge&logo=delphi)
![Flutter](https://img.shields.io/badge/Flutter-Dart-02569B?style=for-the-badge&logo=flutter)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge&logo=amazon-aws)


Conversor de moedas full stack robusto e performático, construído com **Lazarus (Free Pascal)** para o backend e **Flutter** para o frontend. O projeto demonstra um ciclo de vida completo de desenvolvimento, incluindo cache no servidor, temas customizáveis e implantação na nuvem AWS.
</div>

---

## ✨ Features

* **💰 Conversão Multi-Moeda:** Suporte para conversão em tempo real entre as principais moedas fiduciárias (USD, BRL, EUR, etc.) utilizando a [AwesomeAPI](https://docs.awesomeapi.com.br).
* **₿ Criptomoedas:** Módulo dedicado para conversão de criptomoedas (Bitcoin, Ethereum, etc.) com cotação simultânea em Dólar e Real.
* **📜 Histórico Local:** Registro automático das conversões realizadas, persistido localmente no dispositivo.
* **⚡ Cache Inteligente:** Backend em Lazarus com sistema de cache para reduzir latência e prevenir bloqueios de API (`Erro 429`).
* **🎨 Temas Customizáveis:** Interface moderna com seletor de paletas de cores (Azul, Vermelho, Amarelo e Verde) gerenciado via Provider.
* **📱 Interface Reativa:** Navegação fluida com Sidebar, validação de inputs e formatação em tempo real.
* **☁️ Deploy na AWS:** Backend totalmente funcional hospedado em servidor EC2.

---

## 🛠️ Stack de Tecnologias

* **Backend:**
    * **Linguagem:** Free Pascal (com Lazarus IDE)
    * **Framework:** [Horse](https://github.com/HashLoad/horse)
    * **Middleware JSON:** [Jhonson](https://github.com/HashLoad/jhonson)
* **Frontend:**
    * **Framework:** [Flutter](https://flutter.dev/) (Dart)
    * **Gerenciamento de Estado:** Provider (`ChangeNotifier`)
    * **Arquitetura:** MVVM aprimorada (com camada de `Repository`)
    * **Persistência:** `shared_preferences` para histórico local
* **Infraestrutura (Deploy):**
    * **Cloud:** [Amazon Web Services (AWS)](https://aws.amazon.com/)
    * **Serviço:** EC2 (Windows Server 2019)

---

## ⚙️ Como Executar Localmente

### Pré-requisitos

* [Lazarus IDE](https://www.lazarus-ide.org/) instalado.
* [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
* DLLs do OpenSSL (`libeay32.dll` e `ssleay32.dll`) na pasta do backend.

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
4.  Instale as dependências e execute o app:
    ```bash
    flutter pub get
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