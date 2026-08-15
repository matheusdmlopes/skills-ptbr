# Quando usar Mocks

Faça mock apenas nos **divisas do sistema**:

- APIs externas (pagamento, e-mail, etc.)
- Bancos de dados (às vezes - prefira um banco de dados de teste)
- Tempo/aleatoriedade
- Sistema de arquivos (às vezes)

Não faça mock de:

- Suas próprias classes/módulos
- Colaboradores internos
- Qualquer coisa que você controle

## Projetando para Facilidade de Mock

Nos divisas do sistema, projete interfaces que sejam fáceis de mockar:

**1. Use injeção de dependência**

Passe dependências externas para dentro em vez de criá-las internamente:

```typescript
// Fácil de mockar
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Difícil de mockar
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Prefira interfaces no estilo SDK a funções genéricas de busca**

Crie funções específicas para cada operação externa em vez de uma função genérica com lógica condicional:

```typescript
// BOM: Cada função pode ser mockada de forma independente
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// RUIM: O mock exige lógica condicional dentro do mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

A abordagem com SDK significa:
- Cada mock retorna uma estrutura específica
- Sem lógica condicional na configuração do teste
- Mais fácil de ver quais endpoints um teste exercita
- Segurança de tipos por endpoint
