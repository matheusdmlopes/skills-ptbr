function calcularTotal(itens) {
  if (!itens || itens.length === 0) return 0;
  return itens.reduce((total, item) => total + item.preco * item.quantidade, 0);
}

module.exports = {
  calcularTotal,
};
