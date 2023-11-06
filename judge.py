#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov  5 02:36:50 2023

@author: hantingxuan
"""

import numpy as np
def Judge(signal,result,threshold):
    result2 = []
    # number of changepoints
    for j in range(len(result)):
        if j==0:
            data = signal[0:result[j]]
            result2.append(np.mean(data)) 
        else:
            data = signal[result[j-1]:result[j]]
            result2.append(np.mean(data)) 

    increase = []
    decrease = []
    for j in range(len(result2)):
        if j>0:
            if result2[j]-result2[j-1] >= threshold:
                increase.append(result[j-1])
            if result2[j]-result2[j-1] <= -threshold:
                decrease.append(result[j-1])
    result = dict()
    result['increase']=increase
    result['decrease']=decrease
    return(result)

def is_odd(number):
    return number % 2 != 0


