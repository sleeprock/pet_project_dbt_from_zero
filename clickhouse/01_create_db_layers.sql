CREATE DATABASE IF NOT EXISTS raw
COMMENT 'Сырой слой: сырые данные из источников';

CREATE DATABASE IF NOT EXISTS bronze
COMMENT 'bronze слой: данные технически подготовленные к работе';

CREATE DATABASE IF NOT EXISTS silver
COMMENT 'silver слой: данные, подготовленные для построение витрин';

CREATE DATABASE IF NOT EXISTS gold
COMMENT 'gold слой: данные для аналитики, витрины';