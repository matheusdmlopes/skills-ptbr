Abaixo está a execução completa do ciclo de TDD seguindo estritamente as regras da skill.

---

### 1. Definição da Costura (Seam) e Interface Pública

> **Regra da skill ("Costuras: onde os testes ficam"):**
> *"Uma costura é o limite público no qual você testa: a interface onde você observa o comportamento sem mexer no que está dentro. Os testes vivem nas costuras, nunca contra detalhes internos."*

- **Costura sob teste:** função pública [`calcularTotal(itens)`](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.js#L1-L4) exportada pelo módulo [carrinho.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.js).
- **Contrato:** recebe uma lista de objetos `{ preco, quantidade }` e retorna o valor numérico total acumulado.
- **Evitando antipadrões:**
  - *Não acoplado à implementação:* o teste apenas chama a função pública e verifica o retorno, sem mocks de colaboradores internos nem inspeção de estado privado.
  - *Não tautológico:* as asserções usam valores literais calculados de forma independente (exemplo: `50 * 2 = 100`), e não recalcular a expressão do código no teste.
  - *Fatiamento vertical:* implementamos uma fatia por vez (um teste, uma implementação mínima, repete).

---

### 2. Fatia 1: Total de um carrinho com um único item

#### Etapa 1.1: RED (Teste escrito primeiro)
> **Regra da skill ("Red antes de green"):**
> *"Escreva o teste que falha primeiro e, em seguida, apenas código suficiente para fazê-lo passar. Não antecipe testes futuros nem adicione recursos especulativos."*

Criamos o arquivo [carrinho.test.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.test.js) com o primeiro caso de teste antes de existir qualquer código de produção:

```javascript
const test = require('node:test');
const assert = require('node:assert/strict');
const { calcularTotal } = require('./carrinho');

test('deve calcular o total de um carrinho com um unico item', () => {
  const itens = [{ preco: 50, quantidade: 2 }];
  const resultado = calcularTotal(itens);
  assert.strictEqual(resultado, 100);
});
```

**Execução no terminal (`node --test carrinho.test.js`):**
```text
Error: Cannot find module './carrinho'
✖ carrinho.test.js (38.737476ms)
ℹ tests 1
ℹ suites 0
ℹ pass 0
ℹ fail 1
```
*Resultado: FALHOU (RED)* porque o módulo ainda não existe.

---

#### Etapa 1.2: GREEN (Implementação mínima)
Criamos o módulo [carrinho.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.js) com apenas o código suficiente para satisfazer a Fatia 1:

```javascript
function calcularTotal(itens) {
  if (!itens || itens.length === 0) return 0;
  return itens[0].preco * itens[0].quantidade;
}

module.exports = {
  calcularTotal,
};
```

**Execução no terminal (`node --test carrinho.test.js`):**
```text
✔ deve calcular o total de um carrinho com um unico item (0.654173ms)
ℹ tests 1
ℹ suites 0
ℹ pass 1
ℹ fail 0
```
*Resultado: PASSOU (GREEN).*

---

### 3. Fatia 2: Total de um carrinho com múltiplos itens

#### Etapa 2.1: RED (Adição do teste para múltiplos itens)
> **Regra da skill ("Uma fatia por vez" e "Antipadrão: Fatiamento horizontal"):**
> *"Trabalhe em fatias verticais: um teste -> uma implementação -> repita, cada teste sendo uma bala traçante que responde ao que o último ciclo ensinou."*

Adicionamos o segundo teste em [carrinho.test.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.test.js):

```javascript
test('deve calcular o total de um carrinho com multiplos itens', () => {
  const itens = [
    { preco: 10, quantidade: 2 },
    { preco: 30, quantidade: 1 },
  ];
  const resultado = calcularTotal(itens);
  assert.strictEqual(resultado, 50);
});
```

**Execução no terminal (`node --test carrinho.test.js`):**
```text
✔ deve calcular o total de um carrinho com um unico item (0.682366ms)
✖ deve calcular o total de um carrinho com multiplos itens (0.763368ms)

✖ failing tests:
✖ deve calcular o total de um carrinho com multiplos itens (0.763368ms)
  AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
  20 !== 50
    actual: 20,
    expected: 50
```
*Resultado: FALHOU (RED)* pois a implementação anterior só considerava o primeiro item (calculou `10 * 2 = 20` em vez de `50`).

---

#### Etapa 2.2: GREEN (Generalização para múltiplos itens)
Atualizamos [carrinho.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.js) com a agregação de todos os itens:

```javascript
function calcularTotal(itens) {
  if (!itens || itens.length === 0) return 0;
  return itens.reduce((total, item) => total + item.preco * item.quantidade, 0);
}

module.exports = {
  calcularTotal,
};
```

---

### 4. Execução Final de Todos os Testes

Executamos a suíte de testes completa:

```bash
node --test carrinho.test.js
```

**Saída:**
```text
✔ deve calcular o total de um carrinho com um unico item (0.72196ms)
✔ deve calcular o total de um carrinho com multiplos itens (0.140896ms)
ℹ tests 2
ℹ suites 0
ℹ pass 2
ℹ fail 0
ℹ cancelled 0
ℹ skipped 0
ℹ todo 0
ℹ duration_ms 53.595025
```

### Arquivos Criados
- [carrinho.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.js): implementação de [`calcularTotal`](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.js#L1-L4).
- [carrinho.test.js](file:///tmp/claude-1000/-home-matheusdm-Desktop-projetos-skills/1db0bea1-3787-44a7-8592-9d311f219ab4/scratchpad/teste-tdd/carrinho.test.js): testes automatizados nas costuras públicas em duas fatias verticais.
