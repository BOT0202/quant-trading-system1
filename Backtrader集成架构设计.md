# Backtrader框架集成架构设计

## 🏗️ 架构概述

### 设计目标
构建一个基于Backtrader的、可扩展的、高性能的外盘黄金量化交易信号系统。

### 设计原则
1. **模块化**: 各功能模块独立，便于开发和维护
2. **可扩展**: 支持新策略、新数据源、新功能的快速接入
3. **高性能**: 优化数据处理和计算性能
4. **可靠性**: 确保系统稳定运行，具备容错能力
5. **易用性**: 提供友好的开发接口和使用体验

## 📐 系统架构图

```
┌─────────────────────────────────────────────────────────────┐
│                   用户界面层 (Presentation Layer)           │
├─────────────────────────────────────────────────────────────┤
│  Web前端 (Vue.js)      │  移动端 (React Native)   │  API客户端 │
└────────────────────────┴──────────────────────────┴──────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   业务逻辑层 (Business Logic Layer)         │
├─────────────────────────────────────────────────────────────┤
│  Django REST Framework │  任务队列 (Celery)   │  缓存 (Redis)  │
└────────────────────────┴──────────────────────┴──────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│              Backtrader策略引擎层 (Strategy Engine)         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ 策略管理器  │  │ 回测引擎    │  │ 实盘引擎    │        │
│  ├─────────────┼─────────────┼─────────────┤        │
│  │ 风险控制    │  │ 性能分析    │  │ 订单管理    │        │
│  └─────────────┴─────────────┴─────────────┘        │
└─────────────────────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   数据访问层 (Data Access Layer)            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ 本地数据库  │  │ 外部数据源  │  │ 实时数据流  │        │
│  │ (PostgreSQL)│  │ (Binance/IB)│  │ (WebSocket) │        │
│  └─────────────┴─────────────┴─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 核心模块设计

### 1. Backtrader集成模块

#### 模块职责
- 封装Backtrader核心功能
- 提供统一的策略开发接口
- 管理策略生命周期
- 处理数据格式转换

#### 类设计
```python
class GoldQuantBacktrader:
    """Backtrader核心集成类"""
    
    def __init__(self, config):
        self.cerebro = bt.Cerebro()
        self.config = config
        self.strategies = {}
        self.data_feeds = {}
        self.analyzers = {}
    
    def add_strategy(self, name, strategy_class, **params):
        """添加交易策略"""
        self.strategies[name] = {
            'class': strategy_class,
            'params': params,
            'instance': None
        }
        self.cerebro.addstrategy(strategy_class, **params)
    
    def add_data_feed(self, name, data_source, symbol, timeframe):
        """添加数据源"""
        data = self._fetch_data(data_source, symbol, timeframe)
        data_feed = bt.feeds.PandasData(dataname=data)
        self.data_feeds[name] = data_feed
        self.cerebro.adddata(data_feed, name=name)
    
    def run_backtest(self, start_date, end_date, initial_cash=100000):
        """运行回测"""
        self.cerebro.broker.setcash(initial_cash)
        self.cerebro.broker.setcommission(commission=0.001)
        self._add_analyzers()
        return self.cerebro.run()
    
    def run_live(self):
        """运行实盘交易"""
        # 实盘交易逻辑
        pass
    
    def _fetch_data(self, source, symbol, timeframe):
        """获取数据"""
        # 数据获取逻辑
        pass
    
    def _add_analyzers(self):
        """添加分析器"""
        self.cerebro.addanalyzer(bt.analyzers.SharpeRatio, _name='sharpe')
        self.cerebro.addanalyzer(bt.analyzers.DrawDown, _name='drawdown')
        self.cerebro.addanalyzer(bt.analyzers.Returns, _name='returns')
```

### 2. 策略管理器

#### 模块职责
- 策略的注册、加载、卸载
- 策略参数管理
- 策略版本控制
- 策略性能监控

#### 类设计
```python
class StrategyManager:
    """策略管理器"""
    
    def __init__(self):
        self.strategies = {}  # 已注册策略
        self.running_strategies = {}  # 运行中策略
        self.performance_data = {}  # 策略表现数据
    
    def register_strategy(self, strategy_id, strategy_class, metadata):
        """注册策略"""
        self.strategies[strategy_id] = {
            'class': strategy_class,
            'metadata': metadata,
            'created_at': datetime.now(),
            'updated_at': datetime.now()
        }
    
    def load_strategy(self, strategy_id, params=None):
        """加载策略"""
        if strategy_id not in self.strategies:
            raise ValueError(f"策略 {strategy_id} 未注册")
        
        strategy_info = self.strategies[strategy_id]
        strategy_class = strategy_info['class']
        
        # 合并默认参数和传入参数
        default_params = strategy_info['metadata'].get('default_params', {})
        final_params = {**default_params, **(params or {})}
        
        # 创建策略实例
        strategy_instance = strategy_class(**final_params)
        
        self.running_strategies[strategy_id] = {
            'instance': strategy_instance,
            'params': final_params,
            'started_at': datetime.now(),
            'status': 'running'
        }
        
        return strategy_instance
    
    def stop_strategy(self, strategy_id):
        """停止策略"""
        if strategy_id in self.running_strategies:
            self.running_strategies[strategy_id]['status'] = 'stopped'
            self.running_strategies[strategy_id]['stopped_at'] = datetime.now()
    
    def get_performance(self, strategy_id):
        """获取策略表现"""
        return self.performance_data.get(strategy_id, {})
```

### 3. 数据适配器

#### 模块职责
- 统一数据接口
- 数据格式转换
- 数据缓存管理
- 多数据源支持

#### 类设计
```python
class DataAdapter:
    """数据适配器"""
    
    def __init__(self):
        self.sources = {
            'local_db': LocalDataSource(),
            'binance': BinanceDataSource(),
            'interactive_brokers': IBDataSource(),
            'cme': CMEDataSource()
        }
        self.cache = RedisCache()
    
    def get_historical_data(self, source, symbol, timeframe, start_date, end_date):
        """获取历史数据"""
        cache_key = f"{source}:{symbol}:{timeframe}:{start_date}:{end_date}"
        
        # 检查缓存
        cached_data = self.cache.get(cache_key)
        if cached_data:
            return cached_data
        
        # 从数据源获取
        data_source = self.sources.get(source)
        if not data_source:
            raise ValueError(f"数据源 {source} 不支持")
        
        raw_data = data_source.fetch_historical(symbol, timeframe, start_date, end_date)
        
        # 格式转换
        formatted_data = self._format_data(raw_data, timeframe)
        
        # 缓存数据
        self.cache.set(cache_key, formatted_data, ttl=3600)
        
        return formatted_data
    
    def get_realtime_data(self, source, symbol, timeframe):
        """获取实时数据"""
        data_source = self.sources.get(source)
        if not data_source:
            raise ValueError(f"数据源 {source} 不支持")
        
        return data_source.subscribe_realtime(symbol, timeframe)
    
    def _format_data(self, raw_data, timeframe):
        """格式化数据为Backtrader所需格式"""
        formatted = pd.DataFrame(raw_data)
        
        # 确保列名正确
        required_columns = ['datetime', 'open', 'high', 'low', 'close', 'volume']
        for col in required_columns:
            if col not in formatted.columns:
                # 尝试自动映射
                formatted = self._map_columns(formatted)
                break
        
        # 设置索引
        formatted.set_index('datetime', inplace=True)
        
        return formatted
    
    def _map_columns(self, df):
        """自动映射列名"""
        column_mapping = {
            'time': 'datetime',
            'date': 'datetime',
            'timestamp': 'datetime',
            'o': 'open',
            'h': 'high',
            'l': 'low',
            'c': 'close',
            'v': 'volume'
        }
        
        return df.rename(columns=column_mapping)
```

### 4. 风险控制模块

#### 模块职责
- 实时风险监控
- 风险规则执行
- 风险报告生成
- 紧急处理机制

#### 类设计
```python
class RiskManager:
    """风险管理器"""
    
    def __init__(self, config):
        self.config = config
        self.rules = self._load_rules()
        self.alerts = []
        self.actions_taken = []
    
    def monitor_strategy(self, strategy_id, positions, pnl, metrics):
        """监控策略风险"""
        violations = []
        
        for rule in self.rules:
            if self._check_rule(rule, positions, pnl, metrics):
                violations.append(rule)
                self._take_action(rule, strategy_id)
        
        return violations
    
    def _check_rule(self, rule, positions, pnl, metrics):
        """检查规则是否违反"""
        rule_type = rule['type']
        
        if rule_type == 'max_drawdown':
            current_dd = metrics.get('drawdown', 0)
            return current_dd > rule['threshold']
        
        elif rule_type == 'max_position_size':
            total_position = sum(abs(p['size']) for p in positions)
            return total_position > rule['threshold']
        
        elif rule_type == 'daily_loss_limit':
            daily_pnl = pnl.get('daily', 0)
            return daily_pnl < -rule['threshold']
        
        elif rule_type == 'consecutive_losses':
            consecutive_losses = metrics.get('consecutive_losses', 0)
            return consecutive_losses >= rule['threshold']
        
        return False
    
    def _take_action(self, rule, strategy_id):
        """采取风险控制行动"""
        action = rule.get('action', 'alert')
        
        if action == 'alert':
            self._send_alert(rule, strategy_id)
        elif action == 'reduce_position':
            self._reduce_position(strategy_id, rule.get('reduce_by', 0.5))
        elif action == 'stop_strategy':
            self._stop_strategy(strategy_id)
        elif action == 'close_all':
            self._close_all_positions(strategy_id)
        
        self.actions_taken.append({
            'timestamp': datetime.now(),
            'rule': rule,
            'strategy_id': strategy_id,
            'action': action
        })
    
    def _load_rules(self):
        """加载风险规则"""
        return [
            {
                'type': 'max_drawdown',
                'threshold': 0.10,  # 最大回撤10%
                'action': 'alert',
                'message': '回撤超过10%'
            },
            {
                'type': 'max_position_size',
                'threshold': 100000,  # 最大持仓10万
                'action': 'reduce_position',
                'reduce_by': 0.5,
                'message': '持仓超过限额，减仓50%'
            },
            {
                'type': 'daily_loss_limit',
                'threshold': 5000,  # 单日最大亏损5000
                'action': 'stop_strategy',
                'message': '单日亏损超过5000，停止策略'
            },
            {
                'type': 'consecutive_losses',
                'threshold': 5,  # 连续亏损5次
                'action': 'alert',
                'message': '连续亏损5次'
            }
        ]
```

## 🔗 接口设计

### REST API接口

#### 策略管理接口
```
GET    /api/v1/strategies           # 获取策略列表
POST   /api/v1/strategies           # 创建新策略
GET    /api/v1/strategies/{id}      # 获取策略详情
PUT    /api/v1/strategies/{id}      # 更新策略
DELETE /api/v1/strategies/{id}      # 删除策略
POST   /api/v1/strategies/{id}/run  # 运行策略
POST   /api/v1/strategies/{id}/stop # 停止策略
```

#### 回测接口
```
POST   /api/v1/backtest             # 执行回测
GET    /api/v1/backtest/{id}        # 获取回测结果
GET    /api/v1/backtest/{id}/report # 获取回测报告
```

#### 数据接口
```
GET    /api/v1/data/historical      # 获取历史数据
GET    /api/v1/data/realtime        # 获取实时数据
GET    /api/v1/data/sources         # 获取数据源列表
POST   /api/v1/data/sources         # 添加数据源
```

#### 风险接口
```
GET    /api/v1/risk/rules           # 获取风险规则
POST   /api/v1/risk/rules           # 添加风险规则
GET    /api/v1/risk/alerts          # 获取风险告警
GET    /api/v1/risk/report          # 获取风险报告
```

### WebSocket接口

#### 实时数据推送
```javascript
// 连接WebSocket
const ws = new WebSocket('ws://localhost:8000/ws/data');

// 订阅数据
ws.send(JSON.stringify({
    action: 'subscribe',
    channel: 'gold_price',
    symbol: 'XAUUSD',
    timeframe: '1m'
}));

// 接收数据
ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log('实时数据:', data);
};
```

#### 策略信号推送
```javascript
// 订阅策略信号
ws.send(JSON.stringify({
    action: 'subscribe',
    channel: 'strategy_signals',
    strategy_id: 'gold_trend_001'
}));
```

## 🗄️ 数据库设计

### 策略表 (strategies)
```sql
CREATE TABLE strategies (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    strategy_class VARCHAR(255) NOT NULL,
    parameters JSONB,
    status VARCHAR(50) DEFAULT 'inactive',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    version INTEGER DEFAULT 1
);
```

### 回测结果表 (backtest_results)
```sql
CREATE TABLE backtest_results (
    id UUID PRIMARY KEY,
    strategy_id UUID REFERENCES strategies(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    initial_cash DECIMAL(15,2) NOT NULL,
    final_cash DECIMAL(15,2) NOT NULL,
    total_return DECIMAL(10,4),
    sharpe_ratio DECIMAL(10,4),
    max_drawdown DECIMAL(10,4),
    win_rate DECIMAL(10,4),
    total_trades INTEGER,
    parameters_used JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 交易记录表 (trades)
```sql
CREATE TABLE trades (
    id UUID PRIMARY KEY,
    strategy_id UUID REFERENCES strategies(id),
    symbol VARCHAR(50) NOT NULL,
    direction VARCHAR(10) NOT NULL, -- 'buy' or 'sell'
    entry_price DECIMAL(15,6) NOT NULL,
    exit_price DECIMAL(15,6),
    quantity DECIMAL(15,6) NOT NULL,
    entry_time TIMESTAMP NOT NULL,
    exit_time TIMESTAMP,
    pnl DECIMAL(15,6),
    pnl_percent DECIMAL(10,4),
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 风险事件表 (risk_events)
```sql
CREATE TABLE risk_events (
    id UUID PRIMARY KEY,
    strategy_id UUID REFERENCES strategies(id),
    event_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL, -- 'low', 'medium', 'high', 'critical'
    description TEXT,
    rule_triggered JSONB,
    action_taken VARCHAR(255),
    resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);
```

## 🚀 部署架构

### 开发环境
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Django    │    │  Backtrader │    │ PostgreSQL  │
│   Dev Server│◄──►│   Engine    │◄──►│   Database  │
└─────────────┘    └─────────────┘    └─────────────┘
       │                    │                    │
       ▼                    ▼                    ▼
┌────────