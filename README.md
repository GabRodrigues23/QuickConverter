# 🪙 QuickConverter  
### *Simple Money Converter*  

![Flutter](https://img.shields.io/badge/Frontend-Flutter-blue?logo=flutter)
![Lazarus](https://img.shields.io/badge/Backend-Lazarus-orange)
![API](https://img.shields.io/badge/API-AwesomeAPI-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

Um conversor de moedas simples e direto, desenvolvido em **Flutter** (frontend) e **Lazarus** (backend), utilizando a **AwesomeAPI** para obter cotações em tempo real.

---

## 🚀 Funcionalidades  

- 💱 Converter valores entre diferentes moedas.  
- 🌐 Obter taxas de câmbio atualizadas via API.  
- 💡 Interface moderna, leve e responsiva.  
- 🧠 Estrutura baseada no padrão **MVVM**.  

---

## 🧩 Arquitetura  

O projeto segue o padrão **MVVM (Model–View–ViewModel)**, garantindo separação clara entre interface, lógica e dados.  

### Estrutura de pastas:
```
📂 quickconverter/
 ├── backend/
 │   ├── servermain.pas              # Ponto de entrada da aplicação Lazarus (inicializa o servidor)
 │   ├── controller_conversion.pas   # Controla requisições de conversão
 │   ├── serviceapi.pas              # Comunicação com a AwesomeAPI
 │   ├── utils.pas                   # Funções auxiliares (formatar valores, logs, etc.)
 │   ├── backend.lpi                 # Arquivo de projeto Lazarus
 │   ├── backend.lpr                 # Arquivo principal de execução
 |   ├── boss.json                   # Gerenciador de dependencias
 │   └── boss-lock.json
 │
 ├── frontend/
 │   ├── lib/
 │   │   ├── model/
 │   │   │   ├── currency_model.dart
 │   │   │   └── conversion_result.dart
 │   │   ├── viewmodel/
 │   │   │   └── converter_viewmodel.dart
 │   │   ├── view/
 │   │   │   └── converter_page.dart
 │   │   └── main.dart
 │   └── assets/
 │       └── icons/
 │
 ├── docs/
 │   ├── moneyconverter_doc.md
 │   └── api_reference.md
 │
 ├── README.md
 ├── LICENSE
 └── .gitignore

```

---

## ⚙️ Tecnologias Utilizadas  

| Camada | Tecnologia | Descrição |
|--------|-------------|-----------|
| 💻 **Frontend** | Flutter | Interface multiplataforma (Android, iOS, Desktop) |
| ⚙️ **Backend** | Lazarus (Free Pascal) | Lógica e integração da API |
| 🌐 **API Externa** | AwesomeAPI | Fornece cotações em tempo real |
| 🧠 **Arquitetura** | MVVM | Estrutura modular e escalável |
| 🎨 **Design** | Figma | Protótipo visual e layout da interface |
| 🔁 **Versionamento** | Git / GitHub | Controle de versão do projeto |

---

## 🧾 Exemplo de Requisição  

**Endpoint base:**  
```
https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL
```

**Exemplo de retorno:**  
```json
{
    "originalAmount": "1.00",
    "fromCurrency": "USD",
    "toCurrency": "BRL",
    "convertedValue": "5.48"
}
```

**Cálculo aplicado:**  
```
valorConvertido = valorDigitado * bid
```

---

## ▶️ Como Executar  

### 🧠 Backend (Lazarus)
1. Abra o arquivo `converter.lpr` no Lazarus.  
2. Compile e execute o servidor local.  

### 💻 Frontend (Flutter)
```bash
flutter pub get
flutter run
```

### ✅ Teste
- Selecione as moedas de origem e destino.  
- Digite o valor desejado.  
- Veja o resultado convertido instantaneamente.  

---

## 🧭 Planejamento Futuro  

- ☕ Cache no backend
- 📜 Histórico de conversões  
- 🎨 Adição de personalização de tema
- 💬 Inclusão de notificações com atualizações em tempo real
- ☁️ Permitir seleção de múltiplas moedas

---

## 📄 Licença  

Este projeto está sob a licença **MIT**.  
Você é livre para usar, modificar e redistribuir o software, desde que mantenha os créditos originais.  

---

## ✨ Autor  

**👨‍💻 Gabriel Rodrigues**  
📅 **Versão:** 1.0  
🔗 **API:** [AwesomeAPI](https://docs.awesomeapi.com.br/api-de-moedas)  

---

> *“Simples, rápido e eficiente — porque converter moedas não precisa ser complicado.”* 💸  
