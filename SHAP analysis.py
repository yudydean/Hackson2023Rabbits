import pandas as pd
from sklearn.ensemble import RandomForestRegressor
import shap
import numpy as np

data=pd.read_csv('C:/Users/yudyd/Desktop/data_scaled.csv', encoding='utf-8')

X = data.iloc[:,1:31]
y = data.iloc[:,0]

regressor = RandomForestRegressor(random_state=2022)
model = regressor.fit(X,y)
y_pred = regressor.predict(X)

explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X)
np.savetxt('C:/Users/yudyd/Desktop/shapres.csv',shap_values,delimiter=',')