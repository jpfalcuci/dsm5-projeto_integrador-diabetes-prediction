from flask import Flask, request, jsonify
import joblib
import numpy as np
import pandas as pd


# Carrega o modelo previamente treinado
svm_model = joblib.load('./svm.pkl')

# Configura o servidor Flask
app = Flask(__name__)


# Função para normalizar os dados
def normalizar(X):
    m, n = X.shape  # m = qtde de objetos e n = qtde de atributos por objeto

    # Inicializa as variáveis de saída
    X_norm = np.zeros((m, n))  # Inicializa X_norm com zeros
    mu = np.mean(X, axis=0)
    sigma = np.std(X, axis=0, ddof=1)

    for i in range(m):
        X_norm[i, :] = (X[i, :] - mu) / sigma

    return X_norm


# Define a rota para previsão
@app.route('/predict', methods=['POST'])
def predict():
    # Recebe os dados de entrada no formato JSON
    data = request.get_json()

    # Extrai as variáveis de entrada e coloca em um array numpy
    try:
        entrada = np.array([
            data['gender'],
            data['age'],
            data['race:AfricanAmerican'],
            data['race:Asian'],
            data['race:Caucasian'],
            data['race:Hispanic'],
            data['race:Other'],
            data['hypertension'],
            data['heart_disease'],
            data['bmi'],
            data['hbA1c_level'],
            data['blood_glucose_level'],
            data['smoking_history_current'],
            data['smoking_history_ever'],
            data['smoking_history_former'],
            data['smoking_history_never'],
            data['smoking_history_not current']
        ]).reshape(1, -1)  # Transformar em 2D para o modelo

        # Carrega o dataset sem normalização (apenas para pegar as colunas)
        file = 'diabetes_dataset_without_normalization.csv'
        df = pd.read_csv(f'./{file}', sep=',')

        # Adiciona a entrada ao dataframe
        df = pd.concat([df, pd.DataFrame(entrada, columns=df.columns)], ignore_index=True)

        # Colunas contínuas para normalização
        continuous_cols = ['age', 'bmi', 'hbA1c_level', 'blood_glucose_level']
        
        # Normaliza apenas as colunas contínuas
        X = df[continuous_cols].values
        X_norm = normalizar(X)

        # Substitui as colunas contínuas normalizadas no dataframe original
        df[continuous_cols] = X_norm

        # Coleta a entrada normalizada (última linha)
        entrada_normalizada = df.iloc[-1].values

        # Faz a previsão usando o modelo carregado
        previsao = svm_model.predict([entrada_normalizada])

        # Responde com o resultado
        return jsonify({"diabetes": int(previsao[0])})  # 1 para positivo, 0 para negativo

    except KeyError as e:
        # Caso faltem dados na entrada
        return jsonify({"error": f"Dados de entrada incompletos: {str(e)}"}), 400

# Inicia o servidor
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
