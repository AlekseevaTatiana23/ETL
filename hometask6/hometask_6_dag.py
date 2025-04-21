from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
from random import randint
import requests

dag = DAG("hometask_dag", 
	start_date=datetime(2021, 1 ,1),
	schedule_interval='@daily',
	catchup=False)
	
def square_random_num():
	num = randint (1, 1000)
	square_num = num ** 2
	print(f"Number is {num}, it's square is {square_num}")
	
random_num_operator = BashOperator(
        task_id="random_task",
        bash_command="echo $[(RANDOM %100)]",
		dag = dag
        )
		
square_num_operator	= PythonOperator(
        task_id="square_task",
        python_callable=square_random_num,
        dag = dag
        )

def get_weather():
		url = "https://goweather.herokuapp.com/weather/minsk"
		headers = {"Content-Type": "application/json"}
		response = requests.get(url, headers = headers)
		if response.status_code == 200:
			weather_data = response.json()
			return weather_data
		else:
			return "Error"
			
weather_operator = PythonOperator(
	task_id = "get_weather",
	python_callable=get_weather,
	provide_context=True,
	dag=dag)
    
random_num_operator >> square_num_operator >> weather_operator