# Bons e Maus Testes

## Bons Testes

**No estilo de integração**: Teste por meio de interfaces reais, não mocks de partes internas.

```typescript
// BOM: Testa comportamento observável
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Características:

- Testa o comportamento com o qual usuários/chamadores se importam
- Usa apenas a API pública
- Sobrevive a refatorações internas
- Descreve O QUE, não COMO
- Uma asserção lógica por teste

## Maus Testes

**Testes de detalhes de implementação**: Acoplados à estrutura interna.

```typescript
// RUIM: Testa detalhes de implementação
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Sinais de alerta:

- Fazer mock de colaboradores internos
- Testar métodos privados
- Fazer asserções sobre contagem/ordem de chamadas
- O teste quebra na refatoração sem que haja mudança de comportamento
- O nome do teste descreve COMO e não O QUE
- Verificar por meios externos em vez de pela interface

```typescript
// RUIM: Ignora a interface para verificar
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// BOM: Verifica por meio da interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Testes tautológicos**: O valor esperado repete a implementação, fazendo o teste passar por construção.

```typescript
// RUIM: O valor esperado é recalculado da mesma forma que o código calcula
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// BOM: O valor esperado é um literal independente e conhecido
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
