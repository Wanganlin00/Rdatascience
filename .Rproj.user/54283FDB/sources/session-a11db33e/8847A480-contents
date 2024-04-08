---
knitr: 
  opts_chunk: 
    comment: "#>>>"
    collapse: TRUE
number-sections: true
code-fold: show
code-link: true
code-tools: true
---

# 文件处理

## 读取文件

```{python}
f = open("data/pi_digits.txt",mode="r")
contents = f.read()
print(contents)
contents = contents.rstrip()
print(contents)
f.close()
```

```{python}
with open("data/pi_digits.txt",mode="r") as g:
    for i in g:
        print(i)
```

```{python}
from pathlib import Path
path = Path("data/pi_digits.txt")
f = path.read_text()
f = f.splitlines()
for i in f:
    print(i)
```

## 写入文件

```{python}
with open("data/write.txt",mode="a") as w:
    w.write("Π是无限不循环小数。")
with open("data/write.txt",mode="a") as w:
    w.write("fafhaofhaohfo")
```

## 异常处理

exception

```{python}
def division(dividend,divisor):
    answer = dividend/divisor
    return(answer)
division(4,2)
division(4,0)

def division_(dividend,divisor):
    try:
        answer = dividend/divisor
    except ZeroDivisionError:
        print("You can't divide by 0!")
    else:
        return(answer)
    finally:
        print("OK")
division_(4,2)
division_(4,0)
```

## 存储数据
