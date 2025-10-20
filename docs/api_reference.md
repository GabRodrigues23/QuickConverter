# 🚀 Referência da API - QuickConverter

Este documento fornece os detalhes técnicos para a utilização da API de backend do projeto QuickConverter.

## Endereço Base (Desenvolvimento Local)

```
http://localhost:9000
```
_Para o ambiente de produção, substitua `localhost` pelo IP público do servidor na AWS._

## Autenticação

A API é pública e não requer nenhum tipo de autenticação.

---

## Endpoints

### `GET /ping`

Verifica se o servidor da API está online e respondendo. Útil para diagnósticos de saúde (health check).

* **Parâmetros:** Nenhum.
* **Resposta de Sucesso (`200 OK`)**
    * **Content-Type:** `text/plain`
    * **Corpo:**
        ```
        Pong
        ```

---

### `GET /currencies`

Retorna uma lista com os códigos das moedas suportadas pela aplicação. Este endpoint deve ser usado para popular os menus de seleção (dropdowns) no frontend.

* **Parâmetros:** Nenhum.
* **Exemplo de Requisição Completa**
    ```
    GET http://localhost:9000/currencies
    ```
* **Exemplo de Resposta de Sucesso (`200 OK`)**
    * **Content-Type:** `application/json`
    * **Corpo:**
        ```json
        [
          "USD",
          "BRL",
          "GBP",
          "ARS",
          "EUR",
          "JPY"
        ]
        ```
* **Resposta de Erro (`500 Internal Server Error`)**
    * Ocorre se o backend falhar ao gerar a lista. O corpo da resposta conterá uma mensagem de erro em texto.

---

### `GET /convert`

Realiza a conversão de um valor entre duas moedas especificadas, utilizando a cotação mais recente.

* **Parâmetros (Query)**

| Parâmetro | Tipo | Obrigatório | Descrição | Exemplo |
| :--- | :--- | :--- | :--- | :--- |
| `from` | `string` | Sim | Código da moeda de origem (padrão ISO 4217). | `USD` |
| `to` | `string` | Sim | Código da moeda de destino (padrão ISO 4217). | `BRL` |
| `amount` | `string` | Sim | O valor a ser convertido. Deve usar **ponto (`.`)** como separador decimal. | `150.50` |

* **Exemplo de Requisição Completa**
    ```
    GET http://localhost:9000/convert?from=USD&to=BRL&amount=100
    ```
* **Exemplo de Resposta de Sucesso (`200 OK`)**
    * **Content-Type:** `application/json`
    * **Corpo:**
        ```json
        {
          "originalAmount": "100.00",
          "fromCurrency": "USD",
          "toCurrency": "BRL",
          "convertedValue": "548.02"
        }
        ```
* **Exemplo de Resposta de Erro (`400 Bad Request`)**
    * Ocorre se houver um erro nos parâmetros (ex: valor inválido). A API retornará uma mensagem de erro em texto.
    * **Corpo:**
        ```
        Erro: "abc" is an invalid float
        ```