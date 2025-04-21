import pandas as pd
from sqlalchemy import create_engine

# Configurações do Railway PostgreSQL
DATABASE_URL = "postgresql://postgres:nRNSIrpUhYULjDslKMJbkJrpFkgbjnSY@gondola.proxy.rlwy.net:35131/railway"

# Criar conexão usando SQLAlchemy
engine = create_engine(DATABASE_URL)

# Carregar CSV em um DataFrame do Pandas
df = pd.read_csv("data/Crop_recommendation_PT.csv")

# Enviar para o PostgreSQL
df.to_sql("crops", engine, if_exists="append", index=False)

print("Dados carregados com sucesso!")
