import kaggle
import pandas as pd

# Baixar o dataset do Kaggle
dataset = "atharvaingle/crop-recommendation-dataset"
output_path = "data"
kaggle.api.dataset_download_files(dataset, path=output_path, unzip=True)
print("Download concluído!")

# Carregar csv como dataframe
df = pd.read_csv('data/Crop_recommendation.csv')

# Renomear colunas para português
df.rename(columns={
    'temperature': 'temperatura',
    'humidity': 'umidade',
    'rainfall': 'precipitacao',
    'label': 'rotulo'
}, inplace=True)

print("Colunas renomeadas.")

# Converter colunas numéricas
df[['temperatura', 'umidade', 'precipitacao', 'N', 'P', 'K']] = df[['temperatura', 'umidade', 'precipitacao', 'N', 'P', 'K']].apply(pd.to_numeric, errors='coerce')

# Arredondar números
df = df.round(2)

# Calcular índice de similaridade com as condições médias ideais
variaveis = ['temperatura', 'umidade', 'precipitacao', 'N', 'P', 'K']
medias_por_rotulo = df.groupby('rotulo')[variaveis].mean()

# Função para calcular índice de sucesso de cada plantação tendo em mente valores médios do dataset
def calcular_indice_sucesso(row):
    rotulo = row['rotulo']
    desvios = [abs((row[var] - medias_por_rotulo.loc[rotulo, var]) / medias_por_rotulo.loc[rotulo, var]) * 100 for var in variaveis]
    indice = 100 - (sum(desvios) / len(desvios))
    return round(max(indice, 0), 2)

# Adicionar coluna índice de sucesso
df['indice_sucesso'] = df.apply(calcular_indice_sucesso, axis=1)
print('Coluna "índice_sucesso" adicionada.')

# Função para classificar a temperatura
def calcular_classificadao_temperatura(row):
    temp = row['temperatura']
    if temp <= 15:
        return 'Frio'
    elif 15 < temp <= 30:
        return 'Moderado'
    elif temp > 30:
        return 'Quente'

# Adicionar coluna de classificação de temperatura
df['tipo_temperatura'] = df.apply(calcular_classificadao_temperatura, axis=1)
print('Coluna "tipo_temperatura" adicionada.')

# Função para classificar o PH do solo
def classificar_solo_ph(row):
    ph = row['ph']
    if ph < 5.5:
        return 'Ácido'
    elif 5.5 <= ph <= 7.5:
        return 'Neutro'
    else:
        return 'Alcalino'

# Adicionar coluna de classificação de solo
df['tipo_solo'] = df.apply(classificar_solo_ph, axis=1)
print('Coluna "tipo_solo" adicionada.')

# Função para classificar os nutrientes do solo
def classificar_solo_nutrientes(row):
    N = row['N']
    P = row['P']
    K = row['K']
    
    # Classificação baseada em referências agronômicas
    if N < 40 and P < 15 and K < 100:
        return 'Baixo'
    elif (40 <= N <= 80) and (15 <= P <= 40) and (100 <= K <= 200):
        return 'Médio'
    else:
        return 'Alto'

# Adicionar coluna de classificação de nutrientes do solo
df['solo_nutrientes'] = df.apply(classificar_solo_nutrientes, axis=1)
print('Coluna "solo_nutrientes" adicionada.')

# Traduzir df
df['rotulo'] = df['rotulo'].replace({
    'rice': 'Arroz',
    'maize': 'Milho',
    'chickpea': 'Grão-de-bico',
    'kidneybeans': 'Feijão-vermelho',
    'pigeonpeas': 'Ervilha-pomba',
    'mothbeans': 'Feijão-traça',
    'blackgram': 'Feijão-preto',
    'lentil': 'Lentilha',
    'pomegranate': 'Romã',
    'banana': 'Banana',
    'mango': 'Manga',
    'grapes': 'Uvas',
    'watermelon': 'Melancia',
    'muskmelon': 'Melão',
    'apple': 'Maçã',
    'orange': 'Laranja',
    'papaya': 'Mamão',
    'coconut': 'Coco',
    'cotton': 'Algodão',
    'jute': 'Juta',
    'coffee': 'Café',
    'mungbean': 'Feijão-mungo'
})

# Adicionar coluna de tipo de cultura
tipo_cultura = {
    'Arroz': 'Grão',
    'Milho': 'Grão',
    'Grão-de-bico': 'Grão',
    'Feijão-vermelho': 'Grão',
    'Ervilha-pomba': 'Grão',
    'Feijão-traça': 'Grão',
    'Feijão-preto': 'Grão',
    'Lentilha': 'Grão',
    'Romã': 'Fruta',
    'Banana': 'Fruta',
    'Manga': 'Fruta',
    'Uvas': 'Fruta',
    'Melancia': 'Fruta',
    'Melão': 'Fruta',
    'Maçã': 'Fruta',
    'Laranja': 'Fruta',
    'Mamão': 'Fruta',
    'Coco': 'Fruta',
    'Algodão': 'Fibra',
    'Juta': 'Fibra',
    'Café': 'Grão',
    'Feijão-mungo': 'Grão'
}

df['tipo_cultura'] = df['rotulo'].map(tipo_cultura)
print('Coluna "tipo_cultura" adicionada.')

# Mover 'rotulo' pro fim
colunas = [col for col in df.columns if col != 'rotulo'] + ['rotulo']
df = df[colunas]

print("Transformações concluídas.")

# Salvar CSV
df.to_csv('data/Crop_recommendation_PT.csv', index=False, encoding='utf-8-sig', decimal=",")
print("Arquivo CSV salvo com sucesso!")