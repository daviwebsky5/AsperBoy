local torneira = script.Parent
-- Garantir que AnchorPoint está no canto inferior esquerdo
torneira.AnchorPoint = Vector2.new(0, 1)
-- Posicionar na borda inferior do frame (Y = 1)
torneira.Position = UDim2.new(0, 0, 1, 0)
-- Esticar no eixo X, mantendo altura original
torneira.Size = UDim2.new(1, 0, torneira.Size.Y.Scale, torneira.Size.Y.Offset)

