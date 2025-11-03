# **Documentação Técnica — Quick Converter**

## 🪙 1. Visão Geral do Projeto

**Descrição:**

O *Quick Converter* é um sistema simples de conversão de moedas, desenvolvido com **Lazarus (Free Pascal)** no backend e **Flutter** no frontend, utilizando a **AwesomeAPI** para obtenção das taxas de câmbio.

**Arquitetura:**

- **Frontend:** Flutter (estrutura MVVM aprimorada)
- **Backend:** Lazarus (API intermediária de conversão e cache) 
- **API Externa:** AwesomeAPI (`https://docs.awesomeapi.com.br`)

---

## 🧩 2. Estrutura do Sistema

### 2.1. Fluxo Geral

```
Usuário → Flutter (View) → ViewModel → Repository → Lazarus API → AwesomeAPI (ou Cache) → Retorno → Exibição
```

### 2.2. Camadas da Arquitetura (Frontend)

| Camada | Função | Localização | Observação |
| :--- | :--- | :--- | :--- |
| **UI (Apresentação)** | Interface gráfica, interação do usuário e lógica de apresentação. | `/lib/ui/` | Contém `View`, `ViewModel` e `Widgets`. |
| **Data (Dados)** | Lógica de acesso a dados, modelos e comunicação com a API. | `/lib/data/` | Contém `Model` e `Repository`. |
| **Core** | Elementos transversais e estado global da aplicação. | `/lib/core/` | Contém `Notifiers` (Tema, Menu), `Theme` (Temas) e `Constants`. |

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

### 3.2. Principais Funções (`serviceapi.pas`)

A lógica de conversão é dividida em duas funções principais para maior clareza e robustez:

| Função | Descrição | Parâmetros | Retorno |
| :--- | :--- | :--- | :--- |
| **`GetRate` (Trabalhador)** | Função auxiliar interna. É a **única** que fala com o cache e com a AwesomeAPI. <br> Responsável por buscar **uma** taxa (ex: `USD-BRL`) e por tratar a **inversão simples** (ex: `BRL-USD`). | `FromCur`, `ToCur`: `string` | `double`: A taxa de câmbio. |
| **`ConvertCurrency` (Gerente)** | Função principal exposta ao controller. **Não** fala com a API. <br> Contém a lógica de negócio, decidindo se a conversão é direta, inversa ou cruzada (BRL-bridge) e chamando `GetRate` uma ou duas vezes para calcular a taxa final. | `FromCur`, `ToCur`: `string`<br>`Amount`: `double` | `double`: O valor final convertido. |

### 3.3. Variáveis Importantes (`GetRate` em `serviceapi.pas`)

| Variável | Tipo | Função |
| :--- | :--- | :--- |
| `Url` | String | URL da requisição para a AwesomeAPI, usando o endpoint `/json/last/` para suportar todas as moedas. |
| `ApiPair_ForURL`| String | O par de moedas enviado na URL (ex: "USD-BRL"). |
| `CacheKey_ForJSON`| String | A chave usada para o cache (ex: "USDBRL"). |
| `JsonParsingKey`| String | A chave correta para o parse do JSON retornado pelo endpoint `/last/` (ex: "USD"). |
| `IsInverse` | Boolean | Flag que indica se a função `GetRate` deve retornar `1 / Rate` (ex: para `BRL-USD`). |
| `RateCache` | `TDictionary` | Dicionário em memória que armazena as `TCachedRate`. |
| `fs` | `TFormatSettings`| Record que força o **ponto (`.`)** como separador decimal para compatibilidade. |

### 3.4. Mecanismo de Cache

Para otimizar o desempenho e evitar exceder os limites de requisição da AwesomeAPI (erro HTTP 429 - Too Many Requests), o backend implementa um mecanismo de cache em memória para as cotações de moeda.

**Localização:** A lógica de cache está implementada na unidade `serviceapi.pas`.

**Funcionamento:**

1.  **Estrutura de Dados:** Utiliza-se um `TDictionary<string, TCachedRate>` (`RateCache`) para armazenar as cotações.
    * A **chave** do dicionário é uma string concatenada dos códigos das moedas (ex: `"USDBRL"`).
    * O **valor** é um `record` (`TCachedRate`) que contém a cotação (`Rate: Double`) e o momento em que ela foi obtida (`Timestamp: TDateTime`).
2.  **Fluxo de Requisição:** Quando a função `ConvertCurrency` é chamada:
    * O cache é consultado usando a chave da moeda (ex: `"USDBRL"`).
    * **Cache Hit:** Se a cotação existe no cache e seu `Timestamp` é recente (dentro do limite `CACHE_EXPIRATION_SECONDS`, atualmente **60 segundos**), o valor cacheado é usado diretamente, e a chamada para a AwesomeAPI **não é realizada**.
    * **Cache Miss ou Expirado:** Se a cotação não existe ou está expirada, a função prossegue para buscar o valor na AwesomeAPI.
3.  **Atualização do Cache:** Após obter uma nova cotação da AwesomeAPI, ela é armazenada (ou atualizada) no `RateCache` com o `Timestamp` atual, substituindo qualquer valor antigo para aquele par de moedas.
4.  **Gerenciamento de Concorrência:** Um `TCriticalSection` (`CacheLock`) é utilizado para garantir que o acesso e a modificação do `RateCache` sejam seguros em caso de múltiplas requisições simultâneas, evitando condições de corrida.
5.  **Ciclo de Vida:** O dicionário `RateCache` e o `CacheLock` são criados na seção `initialization` da unit `serviceapi` e liberados na seção `finalization`, garantindo o gerenciamento correto da memória.

**Benefícios:**

* Reduz drasticamente o número de chamadas para a API externa.
* Melhora significativamente o tempo de resposta para requisições repetidas dentro da janela de validade do cache.
* Previne bloqueios por excesso de requisições (Rate Limiting).

---

## 📱 4. Frontend — Flutter

### 4.1. Estrutura de Pastas Final

```
/lib
 ├─ core/
 │   ├─ notifiers/
 │   │   ├─ menu_notifier.dart
 │   │   └─ theme_notifier.dart
 │   ├─ theme/
 │   │   └─ app_themes.dart
 │   └─ constants.dart
 ├─ data/
 │   ├─ model/
 │   │   └─ conversion_result.dart
 │   └─ repository/
 │      └─ conversion_repository.dart
 ├─ ui/
 │   ├─ view/
 │   │   ├─ widgets/
 │   │   │   ├─ side_bar_widget.dart
 │   │   │   └─ currency_input_section.dart
 │   │   └─ converter_page.dart
 │   └─ viewmodel/
 │      └─ converter_viewmodel.dart
 ├─ app.dart
 └─ main.dart
```

### 4.2. Principais Classes e Notifiers

| Arquivo | Classe | Descrição |
| :--- | :--- | :--- |
| `conversion_repository.dart`| `ConversionRepository` | Responsável pela comunicação HTTP com o backend. |
| `converter_viewmodel.dart`| `ConverterViewModel` | Gerencia o estado e lógica da tela de conversão. |
| `theme_notifier.dart` | `ThemeNotifier` | Gerencia o estado global do tema visual da aplicação. |
| `menu_notifier.dart` | `MenuNotifier` | Gerencia o estado global do menu lateral (navegação). |
| `conversion_result.dart`| `ConversionResult` | Modelo dos dados de resultado da conversão. |
| `converter_page.dart`| `ConverterPage` | Widget principal que constrói a UI da tela de conversão. |
| `side_bar_widget.dart` | `SidebarWidget` | Widget que define o menu lateral (Drawer). |
| `currency_input_section.dart`| `CurrencyInputSection`| Widget reutilizável para o bloco de input (dropdown + textfield). |

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
API_URL=http://192.168.2.100:9000
```

---

## 🌐 5. Integração com a AwesomeAPI (Externa)

### 5.1. Endpoint Utilizado pelo Backend

O backend utiliza o endpoint `/last/`, que fornece as cotações mais recentes para os principais pares de moedas em relação ao Real (BRL).

`GET https://economia.awesomeapi.com.br/json/last/USD-BRL`

### 5.2. Exemplo de Resposta Recebida

O endpoint `/last/` retorna um JSON onde a chave é o par concatenado.

```json
{
  "USDBRL": {
    "code": "USD",
    "codein": "BRL",
    "bid": "5.4000",
    ...
  }
}
```

### 5.3. Tratamento de Resposta

-   O backend armazena o `bid` de cada par (ex: `USD-BRL`, `EUR-BRL`) em seu cache.
-   A lógica de conversão cruzada é então aplicada para calcular a taxa final.

---

## 6. API do QuickConverter (Contrato Interno)

Esta seção descreve os endpoints fornecidos pelo nosso próprio backend Lazarus.

| Método | Endpoint | Descrição | Exemplo de Resposta |
| :--- | :--- | :--- | :--- |
| `GET` | `/currencies` | Retorna uma lista com os códigos das moedas suportadas pela aplicação. | `["USD", "BRL", "EUR", ...]` |
| `GET` | `/convert` | Realiza a conversão com base nos parâmetros `from`, `to` e `amount`. | `{"originalAmount": "100.00", ...}` |

---

## 🧮 7. Lógica de Conversão (v2.0)

A lógica de conversão no `serviceapi.pas` foi refatorada para suportar qualquer par de moedas, usando o **Real (BRL)** como moeda-ponte (BRL-bridge).

O fluxo, executado dentro da função `ConvertCurrency` (o "Gerente"), é o seguinte:

1.  **Caso 0: Moedas Iguais (ex: `USD -> USD`)**
    * A taxa (`FinalRate`) é definida como `1.0`.
    * Custo: 0 chamadas de API.

2.  **Caso 1: Conversão Para BRL (ex: `USD -> BRL`)**
    * A função chama `GetRate(USD, BRL)` para buscar a cotação `USD-BRL` (do cache ou da API).
    * `FinalRate` = `Rate(USD-BRL)`.
    * Custo: 1 chamada de `GetRate`.

3.  **Caso 2: Conversão de BRL (ex: `BRL -> USD`)**
    * A função chama `GetRate(BRL, USD)`.
    * A função `GetRate` (o "Trabalhador") identifica a inversão, busca `USD-BRL` e retorna `1 / Rate(USD-BRL)`.
    * `FinalRate` = `1 / Rate(USD-BRL)`.
    * Custo: 1 chamada de `GetRate`.

4.  **Caso 3: Conversão Cruzada (ex: `EUR -> USD`)**
    * O backend identifica que BRL não está envolvido e executa a lógica BRL-bridge.
    * **Passo 3.1:** Chama `GetRate(EUR, BRL)` para obter `Rate_EUR_BRL`.
    * **Passo 3.2:** Chama `GetRate(USD, BRL)` para obter `Rate_USD_BRL`.
    * **Passo 3.3:** Calcula a taxa final:
      **Fórmula:** `FinalRate = Rate_EUR_BRL / Rate_USD_BRL`
    * Custo: 2 chamadas de `GetRate` (que são otimizadas pela lógica de "chamada em lote" e pelo cache).

O `Amount` do usuário é então multiplicado pela `FinalRate` calculada.

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
| `v0.3` | 15/10/2025 |  Estrutura Inicial de layout da UI. |
| `v0.4` | 18/10/2025 | Conexão Full Stack (Frontend ↔ Backend) e refatoração da UI. |
| `v1.0` | 19/10/2025 | **Primeira versão estável com deploy do backend na AWS.** |
| `v1.1` | 23/10/2025 | Adição de armazenamento em Cache. |
| `v1.2` | 28/10/2025 | Adição de Temas Customizáveis, Sidebar de Navegação e melhorias de UI. |
| `v1.3` | 30/10/2025 | Implementação de Lógica de Conversão Cruzada. |
| `v2.0` | 03/11/2025 | **Segunda versão estável.** |

---

## 🚀 10. Melhorias Futuras

-   **Implementar lógica de valores inteiros:** Refatorar o backend para tratar valores monetários como inteiros (centavos) para evitar erros de precisão de ponto flutuante (`double`).
-   **Adicionar histórico de conversões:** Salvar as conversões localmente no dispositivo.
-   **Adicionar conversões de Cryptomoedas:** Adicionar uma nova seção/API para moedas digitais.
-   **Implementar Cache no Cliente:** Adicionar uma segunda camada de cache (no Flutter) para melhorar a performance da UI e permitir uso offline básico.

---

## 🔩 11. Implantação (Deployment) na AWS

### 11.1. Configuração da Instância EC2
---

| Parâmetro | Valor Escolhido | Observação |
| :--- | :--- | :--- |
| **Nome da Instância** | `QuickConverter-Server` | Nome descritivo para identificação. |
| **AMI (Sistema)** | Windows Server 2019 Base | Escolhido por ser elegível ao Free Tier e pela compatibilidade direta com o binário `.exe`. |
| **Tipo da Instância** | `t3.micro` | Incluído no Free Tier da AWS, suficiente para a carga da aplicação. |

### 11.2. Configuração de Rede e Segurança (Security Group)

Foram criadas as seguintes regras de entrada (Inbound Rules) para a instância:

| Porta | Protocolo | Origem | Descrição |
| :--- | :--- | :--- | :--- |
| **3389** | TCP | `SEU_IP_PESSOAL/32` | **(Segurança)** Permite acesso via Área de Trabalho Remota (RDP) **apenas** do IP do desenvolvedor. |
| **9000** | TCP | `0.0.0.0/0` | Permite acesso público de qualquer origem à porta da API do QuickConverter. |

🚨 **Aviso de Segurança:** A porta RDP (3389) **nunca** deve ser exposta a `0.0.0.0/0` (qualquer IP). O acesso deve ser restrito ao IP do administrador para evitar ataques de força bruta.

### 11.3. Processo de Deploy

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

### 11.4. Próximos Passos (Robustez)

-   **Execução como Serviço:** Para garantir que a API reinicie automaticamente com o servidor e continue rodando em segundo plano, o próximo passo é configurar o `backend.exe` para ser executado como um **Serviço do Windows**.
-   **HTTPS:** Implementar um certificado SSL/TLS (ex: via Let's Encrypt ou AWS Certificate Manager) para que a comunicação entre o app e a API seja criptografada (`https://...`).

🚨 **Gerenciamento de Segredos:** A senha de administrador do servidor foi gerada pela AWS e deve ser armazenada em um local seguro (gerenciador de senhas). **NUNCA** deve ser inserida em texto puro em documentações ou versionada em repositórios Git.

---

## 👤 12. Autor

**Gabriel Rodrigues de Oliveira**

*Desenvolvedor Full Stack (Lazarus + Flutter)*
