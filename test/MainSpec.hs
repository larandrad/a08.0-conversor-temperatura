module Main (main) where

import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck

import Run (runWithInput)
import qualified Temperatura as T

-- Comparação aproximada local para valores de ponto flutuante.
-- Evita uma dependência extra apenas para os testes e deixa explícita a tolerância usada.
aproxima :: Double -> Double -> Bool
aproxima x y = abs (x - y) < 1e-9

aproximaPar :: (Double, Double) -> (Double, Double) -> Bool
aproximaPar (x1, y1) (x2, y2) =
  aproxima x1 x2 && aproxima y1 y2

valorDe :: Maybe (Double, Double) -> (Double, Double)
valorDe (Just valor) = valor
valorDe Nothing = error "era esperado um valor Just"

genTemperaturaValida :: Gen Double
genTemperaturaValida = choose (-273.15, 10000.0)

genTemperaturaInvalida :: Gen Double
genTemperaturaInvalida = choose (-10000.0, -273.16)

main :: IO ()
main = hspec $ do
  describe "Função converteTemperatura" $ do
    it "converte zero grau Celsius" $
      valorDe (T.converteTemperatura 0.0) `shouldSatisfy`
        (`aproximaPar` (32.0, 273.15))

    it "converte temperatura positiva" $
      valorDe (T.converteTemperatura 25.0) `shouldSatisfy`
        (`aproximaPar` (77.0, 298.15))

    it "converte temperatura em que Celsius e Fahrenheit coincidem" $
      valorDe (T.converteTemperatura (-40.0)) `shouldSatisfy`
        (`aproximaPar` (-40.0, 233.15))

    it "aceita exatamente o zero absoluto" $
      valorDe (T.converteTemperatura (-273.15)) `shouldSatisfy`
        (`aproximaPar` (-459.67, 0.0))

    it "retorna Nothing para temperatura abaixo do zero absoluto" $
      T.converteTemperatura (-300.0) `shouldBe` Nothing

    prop "retorna Just para temperaturas válidas" $
      forAll genTemperaturaValida $ \celsius ->
        T.converteTemperatura celsius /= Nothing

    prop "retorna Nothing para temperaturas abaixo do zero absoluto" $
      forAll genTemperaturaInvalida $ \celsius ->
        T.converteTemperatura celsius == Nothing

    prop "calcula Fahrenheit e Kelvin pelas fórmulas esperadas" $
      forAll genTemperaturaValida $ \celsius ->
        let resultado = valorDe (T.converteTemperatura celsius)
            esperado = (celsius * 9 / 5 + 32, celsius + 273.15)
         in aproximaPar resultado esperado

  describe "Ação main" $ do
    it "imprime Fahrenheit e Kelvin para uma entrada válida" $ do
      saida <- runWithInput T.main "25\n"
      saida `shouldBe`
        "Digite a temperatura em Celsius: Temperatura em Fahrenheit: 77.00\nTemperatura em Kelvin: 298.15\n"

    it "imprime mensagem de erro para entrada não numérica" $ do
      saida <- runWithInput T.main "abc\n"
      saida `shouldBe`
        "Digite a temperatura em Celsius: Entrada inválida!\n"

    it "imprime mensagem de erro para temperatura abaixo do zero absoluto" $ do
      saida <- runWithInput T.main "-300\n"
      saida `shouldBe`
        "Digite a temperatura em Celsius: Entrada inválida!\n"
