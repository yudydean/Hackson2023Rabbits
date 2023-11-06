#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov  5 00:36:42 2023

@author: hantingxuan
"""
import numpy as np
import pandas as pd
from datetime import datetime
import ruptures as rpt
import matplotlib.pyplot as plt
from matplotlib.pyplot import MultipleLocator
import sys
sys.path.append('/Users/hantingxuan/Desktop/Datathon/')
from judge import Judge 
from judge import is_odd 
# 读取CSV文件
file_path = "/Users/hantingxuan/Desktop/Datathon/carbonmonitor-global_data.csv"
df = pd.read_csv(file_path)
# 显示数据框的前几行
print(df.head())
# # 定义日期格式
date_format = "%d/%m/%Y"
for i in range(len(df['date'])):
    print(i)
    date_object = datetime.strptime(df['date'][i], date_format)
    formatted_date = date_object.strftime("%Y-%m-%d")
    df['date'][i] = formatted_date

data_china = df[df['country']=='China']
print(data_china.head())

china_2019 = data_china.iloc[:2190,]
china_2020 = data_china.iloc[2190:4386,]
china_2021 = data_china.iloc[4386:6576,]
china_2022 = data_china.iloc[6576:8766,]
china_2023 = data_china.iloc[8766:,]

np.sum(china_2019['value'])
np.sum(china_2020['value'])
np.sum(china_2021['value'])
np.sum(china_2022['value'])
China_GT = data_china[data_china['sector']=='Ground Transport']
date = China_GT['date']


value_GT = np.array(data_china[data_china['sector']=='Ground Transport']['value'])
value_I = np.array(data_china[data_china['sector']=='Industry']['value'])
value_P = np.array(data_china[data_china['sector']=='Power']['value'])
value_R = np.array(data_china[data_china['sector']=='Residential']['value'])
# 航空
value_IA = np.array(data_china[data_china['sector']=='International Aviation']['value'])
value_DA = np.array(data_china[data_china['sector']=='Domestic Aviation']['value'])
value_sum = value_GT+value_I+value_IA+value_P+value_R+value_DA

# 陆地交通

signal = np.array(value_GT)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=20)
result = np.array(result)
result = result-1

threshold = np.mean(value_GT)/4
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(1)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,5)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('CO2 Emission From Ground Transportation',fontsize=20,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/GT.png',
            bbox_inches = 'tight')
plt.show()
GT_decrease = date.iloc[decrease]
GT_increase = date.iloc[increase]
print(GT_decrease)
print(GT_increase)


#-------------------------------- 工业

signal = np.array(value_I)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=20)
result = np.array(result)
# rpt.display(signal, result)
result = result-1

threshold = np.mean(value_I)/4
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(4)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,20)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('CO2 Emission From Industry',fontsize=20,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/Industry.png',
            bbox_inches = 'tight')
plt.show()
I_decrease = date.iloc[decrease]
I_increase = date.iloc[increase]
print(I_decrease)
print(I_increase)

#---------------------------- 国际航班
signal = np.array(value_IA)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=20)
result = np.array(result)
# rpt.display(signal, result)
result = result-1

threshold = np.mean(value_IA)/4
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(0.04)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,0.2)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('CO2 Emission From International Aviation',fontsize=20,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/IA.png',
            bbox_inches = 'tight')
plt.show()
IA_decrease = date.iloc[decrease]
IA_increase = date.iloc[increase]
print(IA_decrease)
print(IA_increase)

# 居民
signal = np.array(value_R)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=50)
result = np.array(result)
# rpt.display(signal, result)
# plt.ylim(0,3)
# l = 1538
# plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# plt.show()
# date.iloc[result-1]

threshold = np.mean(value_R)/4
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(1.2)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,6)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('CO2 Emission From Residential',fontsize=20,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/R.png',
            bbox_inches = 'tight')
plt.show()
R_decrease = date.iloc[decrease]
R_increase = date.iloc[increase]
print(R_decrease)
print(R_increase)

# 国内航班
signal = np.array(value_DA)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=50)
result = np.array(result)
# rpt.display(signal, result)
# plt.ylim(0,3)
# l = 1538
# plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# plt.show()
# date.iloc[result-1]

threshold = np.mean(value_DA)/4
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(0.06)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,0.3)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('CO2 Emission From Domestic Aviation',fontsize=20,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/DA.png',
            bbox_inches = 'tight')
plt.show()
DA_decrease = date.iloc[decrease]
DA_increase = date.iloc[increase]
print(DA_decrease)
print(DA_increase)

# power
signal = np.array(value_P)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=20)
result = np.array(result)
# rpt.display(signal, result)
# plt.ylim(0,3)
# l = 1538
# plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# plt.show()
# date.iloc[result-1]

threshold = np.mean(value_P)/4
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(5)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,25)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('CO2 Emission From Power',fontsize=20,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/Power.png',
            bbox_inches = 'tight')
plt.show()
P_decrease = date.iloc[decrease]
P_increase = date.iloc[increase]
print(P_decrease)
print(P_increase)

# 总
signal = np.array(value_sum)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=20)
result = np.array(result)
# rpt.display(signal, result)
# plt.ylim(0,3)
# l = 1538
# plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# plt.show()

threshold = np.mean(value_sum)/5
# threshold = 0
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(9)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,45)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('Total CO2 Emission',fontsize=25,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/total.png',
            bbox_inches = 'tight')
plt.show()
T_decrease = date.iloc[decrease]
T_increase = date.iloc[increase]
print(T_decrease)
print(T_increase)

# 去掉季节性影响
signal = np.array(value_sum-value_P)
algo = rpt.Pelt(model="rbf").fit(signal)
result = algo.predict(pen=20)
result = np.array(result)
# rpt.display(signal, result)
# # plt.ylim(0,3)
# # l = 1538
# # plt.axvline(l,color='red')
# # plt.savefig(p1,dpi=400)
# plt.show()

threshold = np.mean(value_sum-value_R)/5
result2 = Judge(signal, result, threshold)
increase = result2['increase']
decrease = result2['decrease']

fig = plt.figure(figsize=(20, 3), dpi=400)
# plt.rcParams['font.family'] = 'Calibri'
plt.xlabel("Time",fontsize=20,labelpad=15)
plt.ylabel("CO2 Emission",fontsize=20,labelpad=7)
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
y_major_locator=MultipleLocator(7)
plt.plot(date,signal,linewidth=3)
# 设置 x 轴上的标签间隔，这里设置为每两天显示一个标签
plt.gca().xaxis.set_major_locator(plt.matplotlib.dates.DayLocator(interval=100))
# 格式化 x 轴上的日期标签，以避免拥挤
plt.gcf().autofmt_xdate()
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
plt.xlim(0,len(signal))
plt.ylim(0,35)
for l in decrease:
    plt.axvline(l,color='blue')
for l in increase:
    plt.axvline(l,color='red')
# plt.savefig(p1,dpi=400)
# 垂直填充
zero = []
zero.append(0)
zero.append(len(signal)-1)
CP = zero + decrease + increase
sorted_CP = sorted(CP)
for l in range(len(sorted_CP)-1):
    if is_odd(l) != True: # odd
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#d9e6fc', alpha=1)
    else:
        plt.axvspan(sorted_CP[l], sorted_CP[l+1], facecolor='#fcd9e3', alpha=1)
plt.title('Total CO2 Emission Without Power',fontsize=25,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/total_withoutP.png',
            bbox_inches = 'tight')
plt.show()
TS_decrease = date.iloc[decrease]
TS_increase = date.iloc[increase]
print(TS_decrease)
print(TS_increase)


# 按年
file_path = "/Users/hantingxuan/Desktop/Datathon/datay.xlsx"
df2 = pd.read_excel(file_path)
signal = df2['碳排放量（万吨）']
rate = []
for i in range(len(signal)-1):
    rate.append((signal[i+1]-signal[i])/signal[i])

year = df2['年份']

df3 = pd.DataFrame({'year': year[1:], 'rate': rate})


(np.sum(china_2020['value'])-np.sum(china_2019['value']))/np.sum(china_2019['value'])
(np.sum(china_2021['value'])-np.sum(china_2020['value']))/np.sum(china_2020['value'])
(np.sum(china_2022['value'])-np.sum(china_2021['value']))/np.sum(china_2021['value'])

new_row = {'year': '2022', 'rate': (np.sum(china_2022['value'])-np.sum(china_2021['value']))/np.sum(china_2021['value'])}
df3 = df3.append(new_row, ignore_index=True)

fig = plt.figure(figsize=(20, 5), dpi=400)
plt.xlabel("Year",fontsize=30,labelpad=15)
plt.ylabel("Change Ratio",fontsize=30,labelpad=7)
plt.xticks(fontsize=25)
plt.yticks(fontsize=25)
y_major_locator=MultipleLocator(0.05)
plt.plot(df3['year'],df3['rate'],linewidth=3)
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
# plt.xlim(0,len(signal))
plt.ylim(-0.05,0.2)
# plt.axhline(0,color='red')
plt.title('Change Ratio of CO2 Emission',fontsize=30,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/change.png',
            bbox_inches = 'tight')
plt.show()


# 共同富裕
file_path = "/Users/hantingxuan/Desktop/Datathon/scale.csv"
df3 = pd.read_csv(file_path)
signal = df3['index']

year = df3['time']

df4 = pd.DataFrame({'year': year, 'signal': signal})


fig = plt.figure(figsize=(20, 5), dpi=400)
plt.xlabel("Year",fontsize=30,labelpad=15)
plt.ylabel("Index Value",fontsize=30,labelpad=7)
plt.xticks(fontsize=25)
plt.yticks(fontsize=25)
y_major_locator=MultipleLocator(20)
plt.plot(df4['year'],df4['signal'],linewidth=3)
ax=plt.gca()
ax.yaxis.set_major_locator(y_major_locator)
# plt.xlim(0,len(signal))
plt.ylim(-30,50)
# plt.axhline(0,color='red')
plt.title('Time Series of Index',fontsize=30,pad=15)
plt.savefig('/Users/hantingxuan/Desktop/Datathon/index.png',
            bbox_inches = 'tight')
plt.show()



