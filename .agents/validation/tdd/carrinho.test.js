const test = require('node:test');
const assert = require('node:assert/strict');
const { calcularTotal } = require('./carrinho');

test('deve calcular o total de um carrinho com um unico item', () => {
  // Dado um carrinho com 1 item (preco: 50, quantidade: 2)
  const itens = [{ preco: 50, quantidade: 2 }];

  // Quando calculamos o total
  const resultado = calcularTotal(itens);

  // Entao o total deve ser 100
  assert.strictEqual(resultado, 100);
});

test('deve calcular o total de um carrinho com multiplos itens', () => {
  // Dado um carrinho com 2 itens distintos
  const itens = [
    { preco: 10, quantidade: 2 },
    { preco: 30, quantidade: 1 },
  ];

  // Quando calculamos o total
  const resultado = calcularTotal(itens);

  // Entao o total deve ser 50 (20 + 30)
  assert.strictEqual(resultado, 50);
});
