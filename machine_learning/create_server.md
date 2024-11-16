# Criar serviço na máquina virtual Ubuntu 24.04

### Acessar servidor via SSH

``` bash
ssh USER@PUBLIC_IP
```

### Atualizar pacotes

``` bash
sudo apt update && sudo apt upgrade -y
```

### Fazer upload do diretório local do projeto para o servidor

- No terminal local, execute o comando abaixo para copiar o diretório `diabetes_prediction` para o servidor

``` bash
scp -r ./diabetes_prediction USER@PUBLIC_IP:/home/USER/
```

### Criar ambiente virtual

``` bash
sudo apt install python3.12-venv -y
python3 -m venv /home/USER/diabetes_prediction/venv
source /home/USER/diabetes_prediction/venv/bin/activate
pip install -r /home/USER/diabetes_prediction/requirements.txt
```

- Para sair do ambiente virtual, execute o comando abaixo

``` bash
deactivate
```

### Diretório do projeto

``` bash
ls /home/USER/diabetes_prediction
```

- O diretório do projeto deve conter os seguintes arquivos:

``` bash
/home/user/diabetes_prediction/
├── app.py
├── svm.pkl
├── diabetes_dataset_without_normalization.csv
├── requirements.txt
└── venv/
```

### Testar aplicação

- É necessário liberar a porta 5000 nas configurações do servidor Azure

``` bash
source /home/USER/diabetes_prediction/venv/bin/activate
cd /home/USER/diabetes_prediction
python3 app.py
```

- No terminal local, execute o comando abaixo para acessar a aplicação

``` bash
curl -X POST http://PUBLIC_IP:5000/predict -H "Content-Type: application/json" -d \ "{\"gender\": 0, \"age\": 31, \"race:AfricanAmerican\": 0, \"race:Asian\": 0, \"race:Caucasian\": 0, \"race:Hispanic\": 0, \"race:Other\": 1, \"hypertension\": 0, \"heart_disease\": 0, \"bmi\": 27.30, \"hbA1c_level\": 4.8, \"blood_glucose_level\": 99, \"smoking_history_current\": 0, \"smoking_history_ever\": 0, \"smoking_history_former\": 0, \"smoking_history_never\": 1, \"smoking_history_not current\": 0}"
```

- O retorno esperado é um JSON com a previsão do modelo

``` json
{
  "diabetes": 0
}
```

### Configurar o servidor como um serviço no Ubuntu

- Criar arquivo de serviço

``` bash
sudo nano /etc/systemd/system/diabetes_prediction.service
```

- Adicionar o conteúdo abaixo no arquivo

``` bash
[Unit]
Description=Diabetes Prediction
After=network-online.target
Wants=network-online.target

[Service]
User=USER
WorkingDirectory=/home/USER/diabetes_prediction
Environment="PATH=/home/USER/diabetes_prediction/venv/bin"
ExecStart=/home/USER/diabetes_prediction/venv/bin/python /home/USER/diabetes_prediction/app.py
Restart=always
StandardOutput=append:/var/log/diabetes_prediction.log
StandardError=append:/var/log/diabetes_prediction_error.log

[Install]
WantedBy=multi-user.target
```

- Recarregar e iniciar o daemon do systemd

``` bash
sudo systemctl daemon-reload
sudo systemctl restart diabetes_prediction
```

- Habilitar o serviço para iniciar com o sistema

``` bash
sudo systemctl enable diabetes_prediction
```

- Verificar o status do serviço

``` bash
sudo systemctl status diabetes_prediction
```
