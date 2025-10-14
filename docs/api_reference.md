# 🚀 Referência da API - QuickConverter

Este documento fornece os detalhes técnicos para a utilização da API de backend do projeto QuickConverter.

## Endereço Base (Desenvolvimento)

```
http://localhost:9000
```

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

### `GET /convert`

Realiza a conversão de um valor entre duas moedas especificadas, utilizando a cotação mais recente.

* **Parâmetros (Query)**

| Parâmetro | Tipo | Obrigatório | Descrição | Exemplo |
| :--- | :--- | :--- | :--- | :--- |
| `from` | `string` | Sim | Código da moeda de origem (padrão ISO 4217). | `USD` |
| `to` | `string` | Sim | Código da moeda de destino (padrão ISO 4217). | `BRL` |
| `amount` | `string` | Sim | O valor a ser convertido. Deve ser um número válido. | `150.50` |

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

    Se ocorrer um erro (ex: parâmetro faltando, moeda inválida, valor inválido), a API retornará uma mensagem de erro em texto puro.

    * **Content-Type:** `text/plain`
    * **Corpo:**
        ```
        Erro: "abc" is an invalid float
        ```