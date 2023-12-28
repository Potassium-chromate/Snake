# Snake
Implement snake Game on FPGA

## 輸出格式(snake)
每8個bit能儲存一個座標(0~100)，目前蛇身暫定最長為7，可視情況增加
![snake](https://github.com/Potassium-chromate/Snake/blob/main/picture/Snake.png)

## 網格介紹
一共是8*8的網格(黃色的部分)，其中白色設為出界區
![grid](https://github.com/Potassium-chromate/Snake/blob/main/picture/grid.png)

## 狀態機介紹(snake)
* **reset:**
  - 將得分設置為0
  - 蛇頭位置設置在12(網格左上角)
  - 所有蛇身位置設為0
* **head_renew:**
  - 決定蛇頭下一步要往哪邊移動
* **check:**
  - 檢查蛇頭是否出界
  - 檢查蛇頭是否吃到蘋果
* **move:**
  - 移動蛇頭
  - 移動蛇身
* **check_body:**
  - 檢查蛇頭是否咬到蛇身
![FSM](https://github.com/Potassium-chromate/Snake/blob/main/picture/FSM.png)
