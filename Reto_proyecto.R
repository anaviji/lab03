rm(list = ls())

# 1. Cargar las librerías y los datos
library(dplyr)
library(tidyr)

data("mtcars")
df <- as.data.frame(mtcars)
print("Dataframe de mtcars cargado: ")
print(df)

# 2. Selección de columnas y filtrado de filas
df <- df %>% select(mpg, cyl, hp, gear)
df <- df %>% filter(cyl > 4)
print("Dataframe tras seleccionar columnas y filtrar filas:")
print(df)

# 3. Ordenación y renombrado de columnas
df <- df %>% arrange(desc(hp))
df <- df %>% rename(consumo=mpg, potencia=hp)
print("Dataframe tras ordenar y renombrar columnas:")
print(df)

# 4. Creación de nuevas columnas y agregación de datos
df <- df %>% mutate(eficiencia = consumo*potencia)
print("Dataframe tras crear nuevas columnas:")
print(df)
df_avg_consumo_max_potencia <- df %>% 
  group_by(cyl) %>% 
  summarize(consumo_medio = median(consumo), potencia_maxima = max(potencia))
print("Dataframe tras agregar datos:")
print(df_avg_consumo_max_potencia)

# 5. Creación del segundo dataframe y unión de dataframes
df_gear <- data.frame(gear=c(3, 4, 5), tipo_transmision = c("Manual", "Automática", "Semiautomática"))
print("Nuevo dataframe:")
print(df_gear)
df_join <- left_join(df, df_gear, by=c("gear"))
print("Unión de dataframes:")
print(df_join)

# 6. Transformación de formatos
df_longer <- df_join %>% pivot_longer(cols = c(consumo,potencia,eficiencia),names_to = "medida",values_to = "valor")
print("Transformación a longer:")
print(df_longer)
df_longer %>% group_by(cyl, gear, tipo_transmision, medida)
df_wider <- df_longer %>% 
  group_by(cyl, gear, tipo_transmision, medida) %>% 
  summarize(valor_medio = mean(valor)) %>% 
  pivot_wider(id_cols = c(cyl,gear,tipo_transmision), names_from = medida, values_from = valor_medio)
print("Transformación a wider:")
print(df_longer)
