# 运营数据获取工具包

## 📋 工具包概述
本工具包专为运营专家设计，用于自动化收集交易策略和市场数据，支持策略筛选、分析和报告生成。

## 🚀 快速开始

### 1. 环境准备
```bash
# 安装Python依赖
pip install -r requirements.txt

# 或者使用conda
conda create -n strategy-env python=3.9
conda activate strategy-env
pip install -r requirements.txt
```

### 2. 运行数据收集工具
```bash
# 运行数据收集器
python data_collector.py

# 运行策略爬取器
python strategy_scraper.py
```

### 3. 查看结果
运行完成后，将生成以下文件：
- `strategies.db` - SQLite数据库文件
- `strategies_export.csv` - 策略数据CSV文件
- `market_data_export.csv` - 市场数据CSV文件
- `data_collection_report.txt` - 数据收集报告
- `strategy_analysis_report.txt` - 策略分析报告
- `strategy_list.xlsx` - 策略列表Excel文件
- `strategy_list.json` - 策略数据JSON文件

## 🔧 工具详解

### data_collector.py - 数据收集器
**功能**:
- 收集加密货币市场数据
- 收集交易策略示例
- 数据存储到SQLite数据库
- 导出CSV格式数据
- 生成数据收集报告

**使用方法**:
```python
from data_collector import DataCollector

# 初始化收集器
collector = DataCollector("my_strategies.db")

# 收集数据
collector.collect_crypto_data()
collector.collect_strategy_examples()

# 导出数据
collector.export_to_csv()

# 生成报告
collector.generate_report()
```

### strategy_scraper.py - 策略爬取器
**功能**:
- 从量化社区爬取策略
- 从学术论文爬取策略
- 从GitHub爬取开源策略
- 策略分析和评分
- 导出Excel和JSON格式

**使用方法**:
```python
from strategy_scraper import StrategyScraper

# 初始化爬取器
scraper = StrategyScraper("my_strategies.db")

# 爬取策略
scraper.scrape_community_strategies()
scraper.scrape_academic_strategies()
scraper.scrape_github_strategies()

# 分析策略
analysis = scraper.analyze_strategies()

# 导出策略列表
scraper.export_strategy_list()
```

## 📊 数据模型

### 策略表 (strategies)
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER | 主键ID |
| name | TEXT | 策略名称 |
| category | TEXT | 策略类别 |
| source | TEXT | 数据来源 |
| description | TEXT | 策略描述 |
| performance_score | REAL | 性能评分(0-10) |
| risk_level | TEXT | 风险等级(低/中/高) |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

### 市场数据表 (market_data)
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER | 主键ID |
| symbol | TEXT | 交易对符号 |
| price | REAL | 价格 |
| volume | REAL | 交易量 |
| change_percent | REAL | 涨跌幅(%) |
| timestamp | TIMESTAMP | 时间戳 |

## 🎯 使用场景

### 场景1: 策略初步筛选
```bash
# 1. 运行数据收集
python data_collector.py

# 2. 查看高分策略
sqlite3 strategies.db "SELECT name, performance_score FROM strategies WHERE performance_score >= 8.0 ORDER BY performance_score DESC;"

# 3. 导出筛选结果
python -c "
import sqlite3
import pandas as pd
conn = sqlite3.connect('strategies.db')
df = pd.read_sql_query('SELECT * FROM strategies WHERE performance_score >= 8.0', conn)
df.to_excel('high_score_strategies.xlsx', index=False)
print(f'导出{len(df)}个高分策略')
"
```

### 场景2: 定期数据更新
```bash
# 创建定时任务（每天9点运行）
# 在crontab中添加：
0 9 * * * cd /path/to/toolkit && python data_collector.py >> collection.log 2>&1
```

### 场景3: 自定义数据源
```python
# 扩展数据收集器
class CustomDataCollector(DataCollector):
    def collect_custom_strategies(self):
        """收集自定义策略"""
        custom_strategies = [
            {
                "name": "我的自定义策略",
                "category": "自定义",
                "source": "内部开发",
                "description": "基于特定需求的交易策略",
                "performance_score": 8.5,
                "risk_level": "中等"
            }
        ]
        self.save_strategies(custom_strategies, "自定义")
```

## 🔍 数据分析示例

### 策略类别分析
```python
import sqlite3
import pandas as pd

conn = sqlite3.connect('strategies.db')

# 按类别统计
category_stats = pd.read_sql_query('''
SELECT category, 
       COUNT(*) as count,
       AVG(performance_score) as avg_score,
       MIN(performance_score) as min_score,
       MAX(performance_score) as max_score
FROM strategies
GROUP BY category
ORDER BY avg_score DESC
''', conn)

print("策略类别统计:")
print(category_stats.to_string())
```

### 风险收益分析
```python
# 风险收益分析
risk_analysis = pd.read_sql_query('''
SELECT risk_level,
       COUNT(*) as strategy_count,
       AVG(performance_score) as avg_performance,
       COUNT(CASE WHEN performance_score >= 8.0 THEN 1 END) as high_score_count
FROM strategies
GROUP BY risk_level
ORDER BY avg_performance DESC
''', conn)

print("\n风险收益分析:")
print(risk_analysis.to_string())
```

## ⚙️ 配置选项

### 数据库配置
```python
# 使用不同的数据库文件
collector = DataCollector(db_path="production_strategies.db")

# 使用内存数据库（临时分析）
collector = DataCollector(db_path=":memory:")
```

### 数据源配置
```python
# 自定义数据源URL（需要修改代码）
COMMUNITY_URLS = [
    "https://www.quantconnect.com/strategies",
    "https://www.joinquant.com/strategy",
    # 添加更多数据源...
]

ACADEMIC_SOURCES = [
    "SSRN金融论文",
    "arXiv量化论文",
    # 添加更多学术源...
]
```

## 🚨 故障排除

### 常见问题1: 依赖安装失败
```bash
# 使用国内镜像源
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 或者使用conda
conda install pandas beautifulsoup4 requests
```

### 常见问题2: 数据库权限问题
```bash
# 检查文件权限
ls -la strategies.db

# 修改权限
chmod 644 strategies.db
chown $USER strategies.db
```

### 常见问题3: 内存不足
```python
# 使用分块处理大数据
chunk_size = 1000
for chunk in pd.read_sql_query("SELECT * FROM strategies", conn, chunksize=chunk_size):
    process_chunk(chunk)
```

## 📈 性能优化

### 批量插入优化
```python
# 使用executemany提高插入性能
strategies_data = [...]  # 大量数据
cursor.executemany('''
INSERT INTO strategies (name, category, source, description, performance_score, risk_level)
VALUES (?, ?, ?, ?, ?, ?)
''', strategies_data)
```

### 索引优化
```sql
-- 创建索引提高查询性能
CREATE INDEX idx_strategies_score ON strategies(performance_score);
CREATE INDEX idx_strategies_category ON strategies(category);
CREATE INDEX idx_strategies_risk ON strategies(risk_level);
```

## 🔄 扩展开发

### 添加新数据源
1. 在`strategy_scraper.py`中添加新的爬取方法
2. 实现数据解析逻辑
3. 调用`save_strategies`方法保存数据
4. 更新README文档

### 添加新分析功能
1. 创建新的分析类或方法
2. 实现分析算法
3. 生成分析报告
4. 提供使用示例

## 📞 技术支持

### 问题反馈
- GitHub Issues: [项目地址]
- 邮箱: support@quant-trading.com
- 工作群: @技术团队

### 更新日志
- v1.0.0 (2026-04-10): 初始版本发布
  - 基础数据收集功能
  - 策略爬取功能
  - 数据分析和报告生成

### 后续计划
- [ ] 添加实时数据API支持
- [ ] 增加机器学习策略评估
- [ ] 开发Web管理界面
- [ ] 支持更多数据源格式

## 📚 学习资源

### 相关文档
- [Pandas官方文档](https://pandas.pydata.org/docs/)
- [SQLite官方文档](https://www.sqlite.org/docs.html)
- [BeautifulSoup文档](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)

### 参考书籍
- 《Python金融大数据分析》
- 《量化交易：如何建立自己的算法交易业务》
- 《打开量化投资的黑箱》

---

**最后更新**: 2026年4月10日  
**版本**: v1.0.0  
**维护者**: 技术团队  
**许可证**: MIT License