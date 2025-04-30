# GIA - Assistente Virtual para Ferramentaria

API de assistente virtual especializado em ferramentas de usinagem. O GIA ajuda os usuários a encontrar as ferramentas certas com base em perguntas sobre materiais, especificações e aplicações.

## Acesso à API

A API está disponível em: [https://gia3.onrender.com](https://gia3.onrender.com)

## Guia para o Frontend

### Endpoint Principal

- **POST `/ask`**: Endpoint para enviar perguntas

Exemplo de requisição:
```json
{
  "question": "Quais ferramentas posso usar para furar aço inoxidável?"
}
```

Exemplo de resposta:
```json
{
  "answer": "Encontrei os seguintes produtos para você:\n\n**Produto A**\nDimensões: 5-10mm\nTipo de Furo: Passante\nRefrigeração Interna: Sim\nMateriais que pode perfurar:\n• Aços em geral\n• Aços inoxidável\nCódigo do Artigo: 391\nLink: https://webshop.exemplo.com\n\n**Produto B**\n...\n\nPosso ajudar com mais alguma informação sobre esses produtos?",
  "suggestions": [
    "Ferramentas para perfurar aço inoxidável",
    "Refrigeração necessária para inox",
    "Produtos para usinagem de precisão"
  ]
}
```

### Como formatar perguntas

As perguntas devem ser enviadas em linguagem natural. O sistema entende:

- Perguntas sobre materiais: "Quais ferramentas para perfurar alumínio?"
- Perguntas sobre refrigeração: "Preciso de brocas com refrigeração interna"
- Perguntas sobre dimensões: "Ferramentas com diâmetro de 10mm"
- Perguntas sobre tipos de furo: "Quais brocas para furos cegos?"
- Perguntas sobre roscas: "Preciso de uma ferramenta para rosquear aço"
- Pesquisa por código: "Informações sobre o artigo 391"

### Tratamento das respostas

Cada resposta contém:

1. **answer**: Texto formatado em markdown com a resposta do assistente
   - Produtos com suas especificações
   - Mensagens informativas quando não há resultados
   - Respostas conversacionais para saudações

2. **suggestions**: Array com até 3 sugestões de perguntas relacionadas

### Exemplos de implementação no Frontend

```javascript
// Exemplo de envio de pergunta
async function enviarPergunta(pergunta) {
  const response = await fetch('https://gia3.onrender.com/ask', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ question: pergunta })
  });
  
  const data = await response.json();
  
  // Exibir resposta no chat
  exibirResposta(data.answer);
  
  // Exibir sugestões como botões clicáveis
  exibirSugestoes(data.suggestions);
}

// Exemplo de exibição de sugestões
function exibirSugestoes(sugestoes) {
  const container = document.getElementById('sugestoes-container');
  container.innerHTML = '';
  
  sugestoes.forEach(sugestao => {
    const botao = document.createElement('button');
    botao.textContent = sugestao;
    botao.onclick = () => enviarPergunta(sugestao);
    container.appendChild(botao);
  });
}
```

### Observações Importantes

1. As respostas são formatadas em Markdown e devem ser renderizadas como tal no frontend
2. Os produtos geralmente contêm:
   - Nome comercial
   - Dimensões
   - Tipo de furo
   - Refrigeração interna
   - Materiais compatíveis
   - Código do artigo (sort)

3. A interface deve ter:
   - Campo para digitação de perguntas
   - Área para mostrar as respostas formatadas
   - Botões para as sugestões geradas

4. O sistema responde naturalmente a saudações e agradecimentos como "olá", "obrigado", etc.

5. Use o endpoint `/status` para verificar se a API está funcionando corretamente.
   - Pode ser util para implementar um visualizador para saber se a GIA está online ou não.
  

### Cliente para Linha de Comando (Windows)

Para facilitar o uso da API diretamente no Windows, disponibilizamos um script PowerShell que funciona como um cliente de linha de comando.

1. Baixe o arquivo gia3.ps1 do repositório
2. Abra o PowerShell no Windows (busque "PowerShell" no menu Iniciar)
3. Navegue até a pasta onde salvou o arquivo usando o comando cd
4. Execute:
```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

5. Inicie o cliente com:
```
.\gia-chat.ps1
```
