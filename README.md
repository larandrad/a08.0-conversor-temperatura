# Tarefa: Conversor de temperatura

Nesta tarefa, você implementará um pequeno programa interativo em Haskell para converter uma temperatura informada em graus Celsius.

A situação modela uma ferramenta simples de apoio para um laboratório, estação meteorológica ou sistema de monitoramento ambiental. O usuário informa uma temperatura em Celsius; o programa valida a entrada e, quando ela é válida, calcula a temperatura correspondente em Fahrenheit e em Kelvin.

Esta atividade será usada como exercício guiado no início da aula prática. Ela combina três ideias importantes do Capítulo 8:

1. separar uma função pura da ação `main`;
2. validar uma entrada textual com `readMaybe`;
3. formatar valores numéricos com `printf`.

## Regras da conversão

O programa deve ler uma temperatura em graus Celsius.

A entrada é inválida quando:

- o valor digitado não pode ser lido como um número;
- a temperatura é menor que `-273.15`, isto é, menor que o zero absoluto.

Quando a entrada for inválida, o programa deve imprimir exatamente:

```text
Entrada inválida!
```

Quando a entrada for válida, o programa deve imprimir a temperatura equivalente em Fahrenheit e em Kelvin, com duas casas decimais.

As fórmulas são:

```text
F = C * 9 / 5 + 32
K = C + 273.15
```

## O que você deve implementar

Complete o arquivo `src/Temperatura.hs`.

### Função pura

Implemente a função:

```haskell
converteTemperatura :: Double -> Maybe (Double, Double)
```

A função recebe a temperatura em Celsius.

Ela deve retornar:

- `Just (fahrenheit, kelvin)`, quando a temperatura for maior ou igual a `-273.15`;
- `Nothing`, quando a temperatura for menor que `-273.15`.

Exemplos:

```haskell
converteTemperatura 0.0       == Just (32.0, 273.15)
converteTemperatura 25.0      == Just (77.0, 298.15)
converteTemperatura (-40.0)   == Just (-40.0, 233.15)
converteTemperatura (-300.0)  == Nothing
```

### Ação principal

Implemente também:

```haskell
main :: IO ()
```

A ação `main` deve:

1. configurar a saída padrão sem bufferização;
2. solicitar a temperatura em Celsius;
3. tentar converter a entrada para `Double`;
4. usar a função `converteTemperatura` para validar e converter a temperatura;
5. imprimir os resultados com duas casas decimais;
6. imprimir `Entrada inválida!` quando a entrada não obedecer às regras.

Use exatamente este prompt:

```text
Digite a temperatura em Celsius:
```

As linhas de resultado devem seguir exatamente este formato:

```text
Temperatura em Fahrenheit: 77.00
Temperatura em Kelvin: 298.15
```

## Dicas

Para ler um número de forma segura, use `readMaybe`, importada do módulo `Text.Read`:

```haskell
import Text.Read (readMaybe)
```

A função `readMaybe` tenta converter uma string para um valor de algum tipo. Quando a conversão é possível, o resultado é `Just valor`; quando a conversão falha, o resultado é `Nothing`.

```haskell
readMaybe "25.0" :: Maybe Double  -- Just 25.0
readMaybe "abc"  :: Maybe Double  -- Nothing
```

Como ainda não estudamos casamento de padrões em detalhe, você pode verificar o resultado de `readMaybe` com uma expressão condicional. Por exemplo:

```haskell
do
  entrada <- getLine
  let maybeTemperatura = readMaybe entrada :: Maybe Double
  if isNothing maybeTemperatura
    then
      putStrLn "Entrada inválida!"
    else do
      let temperatura = fromJust maybeTemperatura
      print temperatura
      putStrLn "A conversão funcionou."
```

Neste exemplo, o uso de `fromJust` no ramo `else` é seguro porque a própria condição já verificou que a estrutura `Maybe` não é vazia.

As funções `isNothing` e `fromJust` devem ser importadas do módulo `Data.Maybe`:

```haskell
import Data.Maybe (isNothing, fromJust)
```

A função `converteTemperatura` pode ser definida com equações com guardas. Uma guarda pode verificar se a temperatura está abaixo do zero absoluto; a outra pode retornar os valores calculados.

Para formatar valores com duas casas decimais, use a função `printf`, importada do módulo `Text.Printf`:

```haskell
import Text.Printf (printf)
```

Em Haskell, `printf` é uma função de formatação. Quando indicamos que o resultado esperado é uma `String`, ela se comporta de modo semelhante à função `sprintf` da linguagem C: em vez de imprimir diretamente na tela, ela produz uma string formatada.

Por exemplo:

```haskell
linhaFahrenheit :: String
linhaFahrenheit = printf "Temperatura em Fahrenheit: %.2f\n" fahrenheit
```

Depois disso, você pode imprimir a string com `putStr`:

```haskell
putStr linhaFahrenheit
```

Também é possível combinar as duas etapas em uma única linha:

```haskell
putStr (printf "Temperatura em Kelvin: %.2f\n" kelvin :: String)
```

O especificador `%.2f` indica que o número deve ser mostrado com duas casas decimais. O `\n` no final representa uma quebra de linha.

## Exemplos de execução

```shellsession
Digite a temperatura em Celsius: 25
Temperatura em Fahrenheit: 77.00
Temperatura em Kelvin: 298.15
```

```shellsession
Digite a temperatura em Celsius: 0
Temperatura em Fahrenheit: 32.00
Temperatura em Kelvin: 273.15
```

```shellsession
Digite a temperatura em Celsius: -40
Temperatura em Fahrenheit: -40.00
Temperatura em Kelvin: 233.15
```

```shellsession
Digite a temperatura em Celsius: -300
Entrada inválida!
```

```shellsession
Digite a temperatura em Celsius: abc
Entrada inválida!
```

## Como testar

Você pode editar os arquivos fonte em um editor de texto e testá-los com Cabal:

```shellsession
$ cabal build                         # compila o projeto
$ cabal repl conversor-temperatura    # abre o GHCi com o módulo da atividade carregado
$ cabal run conversor-temperatura     # executa o programa interativo
$ cabal test                          # executa os testes automáticos
```

O projeto será corrigido automaticamente pelo GitHub Classroom. Seu código deve passar em todos os testes fornecidos.
