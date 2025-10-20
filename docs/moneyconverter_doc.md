# **Documentação Técnica — Quick Converter**

## 🪙 1. Visão Geral do Projeto

**Descrição:**

O *Quick Converter* é um sistema simples de conversão de moedas, desenvolvido com **Lazarus (Free Pascal)** no backend e **Flutter** no frontend, utilizando a **AwesomeAPI** para obtenção das taxas de câmbio.

**Arquitetura:**

- **Frontend:** Flutter (estrutura MVVM aprimorada)
- **Backend:** Lazarus (API intermediária de conversão) - **API Externa:** AwesomeAPI (`https://docs.awesomeapi.com.br`)

---

## 🧩 2. Estrutura do Sistema

### 2.1. Fluxo Geral

```
Usuário → Flutter (View) → ViewModel → Repository → Lazarus API → AwesomeAPI → Retorno → Exibição
```

### 2.2. Camadas da Arquitetura (Frontend)

| Camada | Função | Localização | Observação |
| :--- | :--- | :--- | :--- |
| **UI (Apresentação)** | Interface gráfica, interação do usuário e lógica de apresentação. | `/lib/ui/` | Contém `View`, `ViewModel` e `Widgets`. |
| **Data (Dados)** | Lógica de acesso a dados, modelos e comunicação com a API. | `/lib/data/` | Contém `Model` e `Repository`. |
| **Core** | Elementos transversais, como constantes e utilitários. | `/lib/core/` | Ex: URL base da API. |

---

## ⚙️ 3. Backend — Lazarus

### 3.1. Estrutura

| Módulo | Função | Unidade (arquivo .pas) |
| :--- | :--- | :--- |
| `ServerMain` | Inicializa o servidor e registra as rotas. | `servermain.pas` |
| `ControllerConversion` | Processa requisições de conversão (`/convert`). | `controller_conversion.pas` |
| `ControllerCurrencies` | Fornece a lista de moedas disponíveis (`/currencies`). | `controller_currencies.pas` |
| `ServiceAPI` | Faz chamadas à AwesomeAPI para obter a cotação. | `serviceapi.pas` |
| `Utils` | Funções auxiliares. | `utils.pas` |

### 3.2. Principais Funções

| Função | Descrição | Parâmetros | Retorno | Unidade (arquivo .pas) |
| :--- | :--- | :--- | :--- | :--- |
| `ControllerCurrencies(...)` | Gera e retorna um array JSON com os códigos das moedas suportadas. | N/A | `TJSONArray` | `controller_currencies.pas` |
| `ConvertCurrency(...)` | Busca a cotação na AwesomeAPI e converte o valor. | `FromCur`, `ToCur`: `string`<br>`Amount`: `double` | `double`: Valor convertido | `serviceapi.pas` |
| `FormatCurrencyJSON(...)` | Formata um valor numérico para uma string com 2 casas decimais e ponto. | `Value`: `double` | `string`: (ex: "123.45") | `utils.pas` |

### 3.3. Variáveis Importantes (`serviceapi.pas`)

| Variável | Tipo | Função |
| :--- | :--- | :--- |
| `Url` | String | URL completa da requisição para a AwesomeAPI (ex: `.../json/last/USD-BRL`). |
| `Pair` | String | Chave do objeto JSON de resposta da AwesomeAPI (ex: "USDBRL"). |
| `Rate` | Double | Armazena a **cotação (taxa de câmbio)** retornada, após conversão para `double`. |
| `RateStr` | String | Armazena o valor da cotação (`bid`) extraído do JSON, ainda como `string`. |
| `Client` | TFPHTTPClient | Instância do cliente HTTP para a requisição `GET`. |
| `JsonData` | TJSONData | Estrutura JSON completa retornada pela AwesomeAPI. |
| `JsonObj` | TJSONObject | Objeto JSON específico do par de moedas. |
| `fs` | TFormatSettings | Record que força o **ponto (`.`)** como separador decimal para compatibilidade. |

---

## 📱 4. Frontend — Flutter

### 4.1. Estrutura de Pastas Final

```
/lib
 ├─ core/
 │   └─ constants.dart
 ├─ data/
 │   ├─ model/
 │   │   └─ conversion_result.dart
 │   └─ repository/
 │      └─ conversion_repository.dart
 ├─ ui/
 │   ├─ view/
 │   │   ├─ widgets/
 │   │   │   └─ currency_input_section.dart
 │   │   └─ converter_page.dart
 │   └─ viewmodel/
 │      └─ converter_viewmodel.dart
 └─ app.dart
 └─ main.dart
```

### 4.2. Principais Classes

| Arquivo | Classe | Descrição |
| :--- | :--- | :--- |
| `conversion_repository.dart`| `ConversionRepository` | Responsável por toda a comunicação HTTP com o backend Lazarus. |
| `converter_viewmodel.dart`| `ConverterViewModel` | Contém o estado da tela (`isLoading`, resultado, etc.) e a lógica de apresentação. |
| `conversion_result.dart`| `ConversionResult` | Modelo que representa a estrutura de dados retornada pela API de conversão. |
| `converter_page.dart`| `ConverterPage` | Widget principal que constrói a interface e reage às mudanças do `ViewModel`. |
| `currency_input_section.dart`| `CurrencyInputSection`| Widget reutilizável que encapsula a UI de um bloco de conversão (dropdown + textfield). |

### 4.3. Gerenciamento de Configuração (.env)

Para separar a configuração do código-fonte e facilitar a alternância entre ambientes (desenvolvimento e produção), o projeto Flutter utiliza um sistema de variáveis de ambiente.

-   **Biblioteca:** `flutter_dotenv`
-   **Arquivo de Configuração:** `.env` (localizado na raiz do projeto frontend).
-   **Funcionamento:** A URL base da API (`apiBaseUrl`) é carregada a partir do arquivo `.env` na inicialização do aplicativo (`main.dart`).
-   **Segurança:** O arquivo `.env` é incluído no `.gitignore` para garantir que chaves e endereços de produção não sejam expostos no repositório de código.

**Exemplo de `.env` para desenvolvimento local:**
```
API_URL=http://localhost:9000
```

**Exemplo de `.env` para produção:**
```
API_URL=[http://3.135.228.217:9000](http://3.135.228.217:9000)
```

---

## 🌐 5. Integração com a AwesomeAPI (Externa)

### 5.1. Endpoint Utilizado pelo Backend

`GET https://economia.awesomeapi.com.br/json/last/USD-BRL`

### 5.2. Exemplo de Resposta Recebida

```json
{
  "USDBRL": {
    "code": "USD",
    "codein": "BRL",
    "name": "Dólar Americano/Real Brasileiro",
    "bid": "5.4000",
    ...
  }
}
```

### 5.3. Tratamento de Resposta

-   A API Lazarus extrai apenas o valor do campo `bid` (preço de compra) para realizar o cálculo.

---

## API do QuickConverter (Contrato Interno)

Esta seção descreve os endpoints fornecidos pelo nosso próprio backend Lazarus.

| Método | Endpoint | Descrição | Exemplo de Resposta |
| :--- | :--- | :--- | :--- |
| `GET` | `/currencies` | Retorna uma lista com os códigos das moedas suportadas pela aplicação. | `["USD", "BRL", "EUR", ...]` |
| `GET` | `/convert` | Realiza a conversão com base nos parâmetros `from`, `to` e `amount`. | `{"originalAmount": "100.00", ...}` |

---

## 🧮 7. Lógica de Conversão

**Fórmula:** `Valor Convertido = Valor Original × Taxa de Câmbio (bid)`

---

## 🧪 8. Testes e Validação

| Tipo | Descrição | Ferramenta |
| :--- | :--- | :--- |
| Unitário | Testes de lógica de negócio e funções puras. | FPCUnit |
| Integração | Teste de comunicação Backend ↔ AwesomeAPI e Frontend ↔ Backend. | Teste manual via Postman |
| UI | Verificação de exibição, formatação e responsividade. | Teste manual e Flutter Widget Tests |

---

## 📅 9. Controle de Versões

| Versão | Data | Alterações |
| :--- | :--- | :--- |
| `v0.1` | 14/10/2025 | Estrutura inicial do projeto |
| `v0.2` | 14/10/2025 | Implementação do backend e integração com AwesomeAPI. |
| `v0.3`| 15/10/2025 |  Estrutura Inicial de layout da UI.
| `v0.4` | 18/10/2025 | Conexão Full Stack (Frontend ↔ Backend) e refatoração da UI. |
| `v1.0` | 19/10/2025 | **Primeira versão estável com deploy do backend na AWS.** |

---

## 🚀 10. Melhorias Futuras

-   **Adicionar funcionalidade de temas:** Para tornar a aplicação mais customizavel.
-   **Adicionar histórico de conversões:** Para manter um registro das operações do usuário.
-   **Implementar cache no backend:** Para diminuir a dependência da AwesomeAPI e otimizar a performance, evitando erros de "Too Many Requests" (HTTP 429).
-   **Notificações em tempo real:** Para manter o usuário informado sobre variações de cotação.

---

## 👤 11. Autor

**Gabriel Rodrigues de Oliveira**

*Desenvolvedor Full Stack (Lazarus + Flutter)*

---

## 🔩 12. Implantação (Deployment) na AWS

*Esta seção detalha o processo de implantação do backend Lazarus em uma instância EC2.*

### 12.1. Configuração da Instância EC2
---

| Parâmetro | Valor Escolhido | Observação |
| :--- | :--- | :--- |
| **Nome da Instância** | `QuickConverter-Server` | Nome descritivo para identificação. |
| **AMI (Sistema)** | Windows Server 2019 Base | Escolhido por ser elegível ao Free Tier e pela compatibilidade direta com o binário `.exe`. |
| **Tipo da Instância** | `t3.micro` | Incluído no Free Tier da AWS, suficiente para a carga da aplicação. |

### 12.2. Configuração de Rede e Segurança (Security Group)

Foram criadas as seguintes regras de entrada (Inbound Rules) para a instância:

| Porta | Protocolo | Origem | Descrição |
| :--- | :--- | :--- | :--- |
| **3389** | TCP | `SEU_IP_PESSOAL/32` | **(Segurança)** Permite acesso via Área de Trabalho Remota (RDP) **apenas** do IP do desenvolvedor. |
| **9000** | TCP | `0.0.0.0/0` | Permite acesso público de qualquer origem à porta da API do QuickConverter. |

🚨 **Aviso de Segurança:** A porta RDP (3389) **nunca** deve ser exposta a `0.0.0.0/0` (qualquer IP). O acesso deve ser restrito ao IP do administrador para evitar ataques de força bruta.

### 12.3. Processo de Deploy

1.  **Conexão Remota:** A conexão com o servidor foi estabelecida via **Área de Trabalho Remota (RDP)**, utilizando o IP público e as credenciais fornecidas pela AWS (descriptografadas com a chave `.pem`).
2.  **Transferência de Arquivos:** O diretório `C:\QuickConverter-Server\` foi criado na instância. Os seguintes arquivos foram transferidos do ambiente de desenvolvimento para este diretório:
    * `backend.exe` (O binário compilado do projeto Lazarus).
    * `libeay32.dll` e `ssleay32.dll` (Dependências do OpenSSL para chamadas HTTPS).
3.  **Liberação no Firewall Interno:** Uma nova regra de entrada foi configurada no **Firewall do Windows Server** para permitir conexões TCP na porta `9000`, garantindo que o "muro interno" não bloqueie as requisições que já passaram pelo "muro externo" (Security Group).
4.  **Execução:** A aplicação foi iniciada manualmente via Prompt de Comando:
    ```cmd
    cd C:\QuickConverter-Server
    backend.exe
    ```

### 12.4. Próximos Passos (Robustez)

-   **Execução como Serviço:** Para garantir que a API reinicie automaticamente com o servidor e continue rodando em segundo plano, o próximo passo é configurar o `backend.exe` para ser executado como um **Serviço do Windows**.
-   **HTTPS:** Implementar um certificado SSL/TLS (ex: via Let's Encrypt ou AWS Certificate Manager) para que a comunicação entre o app e a API seja criptografada (`https://...`).

🚨 **Gerenciamento de Segredos:** A senha de administrador do servidor foi gerada pela AWS e deve ser armazenada em um local seguro (gerenciador de senhas). **NUNCA** deve ser inserida em texto puro em documentações ou versionada em repositórios Git.