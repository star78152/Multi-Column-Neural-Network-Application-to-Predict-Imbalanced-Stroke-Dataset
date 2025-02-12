# 多列類神經網路預測不平衡中風數據集之應用 <br> Multi-Column-Neural-Network-Application-to-Predict-Imbalanced-Stroke-Dataset

## 摘要
隨著技術的便利和人們壓力的增加，缺乏運動，不規律的工時和休息以及不健康的飲食習慣，死亡率和中風人口逐年增加，並且有年輕化的趨勢。在美國平均每40秒就有一人中風，在2017年每19例死亡就有1例是死於中風，全世界有620萬人死於腦血管疾病，2019年全球十大死因佔全球死亡案例5540萬中的55%，其中因Stroke死亡的人數就約有609萬人。數據收集對於人工智能（AI）學習非常重要，但是實際數據通常在類別數量上不平衡，這使AI無法很好地學習。本研究所使用的取樣方法為Oversampling，Undersampling和Synthetic Minority Oversampling Technique (SMOTE)。最後將三種方法訓練的網路模型建構成多列類神經網路(MCNN)，以提高分類準確率。

## 人均預期壽命提高
世界上所有地區的預期壽命(life expectancy，又稱為平均壽命)為 30 歲左右，1800年之前，只有歐洲少數精英階層的人均壽命超過40歲。19世紀初世界所有地區的預期壽命都遠低於40歲，有一半人口在成年前夭折。到了19世紀末，隨著科技和醫療品質的進步才使得人類的預期壽命提高，人類開始在健康狀況不佳的狀態取得進展，流行病學家將預期壽命開始大幅成長的這段時期稱為“健康轉型(health transition)”。 <br>
![No Image!!](/img/Human_Life_Expectancy_Curve_1770_to_2019.jpg "1770~2019年人口預期壽命趨勢圖")

## 方法
AI的學習非常仰賴Data，網路模型需要非常大量的資料去演算及改進，但若數據擁有不平衡的問題時，則會對網路模型的學習造成非常大的問題和困擾。本研究使用的採樣方法有Oversampling、Undersampling和Synthetic Minority Oversampling Technique (SMOTE)。讓ANN透過Supervised Learning的方式和演算法的優化。最後將三種方法訓練的網路模型建構成多列類神經網路(MCNN)，以提高分類準確率。<br>
![No Image!!](/img/Multi_Column_Neural_Network_MCNN.jpg"多列類神經網路(MCNN)")


### 採樣方法
#### Oversampling
把少數樣本通過複製的方式，使樣本類別平衡。使用這方法訓練出來的模型會有一定的過擬合。<br>
![No Image!!](/img/OverSampling.jpg "Oversampling")

#### Undersampling
是對多數樣本通過隨機取樣，使樣本類別跟少數樣本達到平衡。缺點是該模型僅學習到整體數據集的一部分，沒有學習其他到重要訊息。<br>
![No Image!!](/img/UnderSampling.jpg "Undersampling")

#### SMOTE
利用少數樣本的特徵空間的相似性來生成新樣本，在少數樣本的K個最近鄰樣本點中，隨機選取N個鄰近樣本點，從而達到生成一個新的資料的目的。<br>
![No Image!!](/img/SMOTE.jpg "SMOTE")


### 類神經網路 (Artificial Neural Network, ANN)
類神經網路(ANN)是受到人類大腦神經網路的啟發，將大量的神經元連接形成一個類似生物神經網路的網狀結構進行計算，是計算機領域用於處理機器學習問題的強大工具，常應用於辨識、決策、控制、預測等問題中。一般神經網路包括輸入層、隱藏層與輸出層。 <br>  
![No Image!!](/img/Artificial_Neural_Network_Architecture.jpg "ANN架構圖")  

### 訓練演算法
#### Levenberg-Marquardt (LM) Algorithm
Levenberg-Marquardt(LM)演算法也稱為Damped least-squares (DLS)，常用於解決非線性最小二乘問題。結合了梯度下降法和高斯牛頓法來獲得最佳解，具有梯度下降法的全局搜索和高斯牛頓法的快速收斂特性，能夠使神經網路快速收斂，是訓練中等大小的feedforward neural networks(No more than a thousand weights)的最快方法。缺點是需要較大的記憶體需求。

#### Scaled conjugate gradient (SCG) Algorithm
Scaled conjugate gradient (SCG)是常見的監督式學習算法，由Moller在1993年提出的演算法。將LM算法使用的信賴區間法與共軛梯度演算法結合起來，減少用於調整方向時搜尋網路的時間，是一種快速且有效的算法。SCG的記憶體需求相對較小，但是比標準的梯度下降算法要快得多。該演算法通過採用步長縮放機制，避免在了在每次學習反覆運算中所進行的線性搜尋，大幅度的降低計算複雜度。

## Dataset
Dataset: " Kaggle: HealthCare Problem: Prediction Stroke Patients " [27]
Train data  0和1的個數(1 : 54)
Test data 0和1的個數   (1 : 2.8)

Train data <br>
![No Image!!](/img/Train_Data_Output.jpg "Train data筆數")  

Test data <br>
![No Image!!](/img/Test_Data_Output.jpg "Test data筆數")  

Data Features <br>
![No Image!!](/img/Data_features.jpg "資料集特徵")


## 評估標準
### Accuracy
在監督式學習的領域中，常見的評價指標就是Accuracy，它代表該模型預測正確的數量。在數據類別筆數正常的情況下，他能有效的評估模型的好壞，但是當數據的其中一個類別的數量很少時，會使得Accuracy得分非常高。所以如果只使用Accuracy作為唯一的判斷標準，那麼將會遇到準確性悖論(Accuracy paradox)的問題。

### Precision
在分類問題中，Precision(又稱為Positive predictive value)能夠讓我們判斷，該模型在所有預測為陽性的結果中，預測正確的比例有多少，當Precision越高時，代表該模型對於陰性樣本的區分能力越強。

### Recall
Recall(又稱為Sensitivity)該評價指標，代表的意義為在所有陽性樣本中，有多少正確預測陽性樣本的比例，當Recall得分越高時代表模型對正樣本的識別能力越強。

### F1 Score
F1 score綜合了Precision和Recall，常被用來分析分類模型的結果，又被稱為Precision和Recall的Harmonic mean，當F1 score得分越高，說明了該模型越穩健。

### Area Under Curve (AUC)
很多時候ROC和PR曲線並不能清晰的說明哪個分類模型的效果好，故使用AUC判斷ROC和PR曲線的優劣，AUC越大表示該模型的分類效果越好。

AUC判斷分類模型優劣的標準：
* AUC ≦0.5, 跟隨機猜測一樣，模型沒有預測價值。
* 0.5< AUC <1, 優於隨機猜測，具有一定的預測能力。
* AUC = 1.0, 完美的分類模型，屬於理想狀況。

![No Image!!](/img/AUC_ROC.jpg "AUC-ROC")  
![No Image!!](/img/AUC_PR.jpg "AUC-PR")  


## 實驗
本研究使用的數據集為“ Kaggle: HealthCare Problem: Prediction Stroke Patients ”，此數據集提供的train data為不平衡的數據集，陽性和陰性的筆數分別是783跟42617筆。在對train data個別進行三種取樣方法後，將訓練數據分為70%訓練，15%驗證和15%測試。

本研究的實驗流程。訓練數據集會經過三種取樣方法，Oversampling、Undersampling和SMOTE，當訓練數據集完成取樣後，將輸入至ANN做訓練，ANN的所使用的演算法有LM和SCG；考慮了八種網路模型，所使用的隱藏層節點數分別為1、2、5、10、15、20、25和50個節點數，且為了測試該模型的穩定性，我們為每個模型進行了1000次的交叉驗證。  
為了能夠完整的分析模型的訓練結果，在測試訓練模型時，我們使用了七種評分方式，針對三種資料取樣方法、兩種演算法、八種網路架構跟未處理的數據集進行分析比較，最後網路模型則會經過七種評分指標來決定最終選擇哪些模型建構MCNN。

![No Image!!](/img/Implemented_process.jpg "實驗流程") 


### 實驗結果
本實驗從七種評分指標中，最終選擇F1 score當作我們挑選模型的依據。最後從三種取樣方法各選出最佳F1 score的模型，並將其組成多列類神經網路 (MCNN)，透過像多個專家的ANN模型組成的MCNN，該架構能夠提高模型的分類準確率、強健性和穩定性。由單一網路最佳Accuracy的94.28%提升至94.43%、F1 score 也由89.03%提升至89.24%，實現更有效，更成熟的中風預測。


Data_Unbalanced <br>
![No Image!!](/img/Data_Unbalanced_Result.jpg "資料未處理前(Unbalanced) - 模擬結果") 

OverSampling Result <br>
![No Image!!](/img/OverSampling_Result.jpg "OverSampling - 模擬結果") 

UnderSampling Result <br>
![No Image!!](/img/UnderSampling_Result.jpg "UnderSampling - 模擬結果") 

SMOTE Result <br>
![No Image!!](/img/MCNN_Result.jpg "MCNN模擬結果") 


MCNN與各個指標最佳模型比較 <br>
![No Image!!](/img/EvaluationMetric_BestArchitecture.jpg "MCNN與各個指標最佳模型比較") 
