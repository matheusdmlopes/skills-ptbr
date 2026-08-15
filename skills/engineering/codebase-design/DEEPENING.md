# Aprofundamento (Deepening)

Como aprofundar um cluster de módulos rasos com segurança, dadas as suas dependências. Pressupõe o vocabulário em [SKILL.md](SKILL.md) — **módulo**, **interface**, **costura**, **adaptador**.

## Categorias de dependência

Ao avaliar um candidato para aprofundamento, classifique suas dependências. A categoria determina como o módulo aprofundado é testado através de sua costura.

### 1. In-process

Computação pura, estado em memória, sem E/S (I/O). Sempre aprofundável — una os módulos e teste diretamente através da nova interface. Nenhum adaptador é necessário.

### 2. Local-substitutable

Dependências que possuem substitutos (stand-ins) locais de teste (PGLite para Postgres, sistema de arquivos em memória). Aprofundável se o substituto existir. O módulo aprofundado é testado com o substituto rodando na suite de testes. A costura é interna; não há porta na interface externa do módulo.

### 3. Remote but owned (Ports & Adapters)

Seus próprios serviços através de uma divisa de rede (microsserviços, APIs internas). Defina uma **porta** (interface) na costura. O deep module detém a lógica; o transporte é injetado como um **adaptador**. Os testes usam um adaptador em memória. A produção usa um adaptador HTTP/gRPC/fila.

Formato da recomendação: *"Defina uma porta na costura, implemente um adaptador HTTP para produção e um adaptador em memória para testes, para que a lógica fique em um único deep module mesmo que seja implantada através de uma rede."*

### 4. True external (Mock)

Serviços de terceiros (Stripe, Twilio, etc.) que você não controla. O módulo aprofundado recebe a dependência externa como uma porta injetada; os testes fornecem um adaptador mock.

## Disciplina de costuras

- **Um adaptador significa uma costura hipotética. Dois adaptadores significam uma costura real.** Não introduza uma porta a menos que pelo menos dois adaptadores sejam justificados (tipicamente produção + teste). Uma costura de adaptador único é apenas indireção.
- **Costuras internas vs costuras externas.** Um deep module pode ter costuras internas (privadas à sua implementação, usadas por seus próprios testes), bem como a costura externa em sua interface. Não exponha costuras internas através da interface apenas porque os testes as utilizam.

## Estratégia de testes: substituir, não acumular em camadas

- Antigos testes unitários em módulos rasos se tornam desperdício quando os testes na interface do módulo aprofundado existirem — exclua-os.
- Escreva novos testes na interface do módulo aprofundado. A **interface é a superfície de teste**.
- Os testes fazem asserções sobre resultados observáveis através da interface, não sobre o estado interno.
- Os testes devem sobreviver a refatorações internas — eles descrevem comportamento, não implementação. Se um teste tiver que mudar quando a implementação mudar, ele está testando além da interface.
