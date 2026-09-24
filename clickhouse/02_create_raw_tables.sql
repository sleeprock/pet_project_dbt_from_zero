CREATE TABLE
    IF NOT EXISTS raw.ecommerce__users (
        id UInt32 COMMENT 'Уникальный идентификатор пользователя',
        first_name String COMMENT 'Имя пользователя',
        last_name String COMMENT 'Фамилия пользователя',
        email String COMMENT 'Адрес электронной почты',
        age UInt8 COMMENT 'Возраст пользователя в годах',
        gender String COMMENT 'Пол пользователя (M/F)',
        state String COMMENT 'Регион / Штат проживания',
        street_address String COMMENT 'Улица и номер дома проживания',
        postal_code String COMMENT 'Почтовый индекс',
        city String COMMENT 'Город проживания',
        country String COMMENT 'Страна проживания',
        traffic_source String COMMENT 'Источник привлечения пользователя на сайт',
        created_at DateTime COMMENT 'Дата и время регистрации пользователя (UTC)',
        _loaded_at DateTime DEFAULT now () COMMENT 'Техническое поле: дата и время загрузки записи в хранилище'
    ) ENGINE = MergeTree ()
PARTITION BY
    toYYYYMM (created_at)
ORDER BY
    id COMMENT 'Сырой слой. Пользователи ecommerce';

CREATE TABLE
    IF NOT EXISTS raw.ecommerce__orders (
        order_id UInt32 COMMENT 'Уникальный идентификатор заказа',
        user_id UInt32 COMMENT 'Идентификатор пользователя',
        status String COMMENT 'Статус заказа',
        created_at DateTime COMMENT 'Дата и время оформления заказа (UTC)',
        returned_at DateTime COMMENT 'Дата и время возврата заказа',
        shipped_at DateTime COMMENT 'Дата и время отгрузки заказа',
        delivered_at DateTime COMMENT 'Дата и время доставки заказа',
        num_of_item UInt8 COMMENT 'Количество товаров в заказе',
        _loaded_at DateTime DEFAULT now () COMMENT 'Техническое поле: дата и время загрузки записи в хранилище'
    ) ENGINE = MergeTree ()
PARTITION BY
    toYYYYMM (created_at)
ORDER BY
    order_id COMMENT 'Сырой слой. Заказы ecommerce';

create table
    if not exists raw.ecommerce__products (
        id UInt32 COMMENT 'Уникальный идентификатор товара (первичный ключ).	1 — 29120',
        cost Decimal(15, 2) COMMENT 'Себестоимость производства или закупки товара.	0.53 — 558',
        category String COMMENT 'Категория товара.	Текст (например, Accessories, Sleep & Lounge)',
        name String COMMENT 'Наименование товара.	Текст (название бренда и модели)',
        brand String COMMENT 'Бренд/производитель товара.	Текст (название торговой марки)',
        retail_price Decimal(15, 2) COMMENT 'Рекомендуемая розничная цена товара в магазине.	0.02 — 999.0',
        department String COMMENT 'Целевой отдел (для кого предназначен товар).	Текст (Men, Women)',
        sku String COMMENT 'Складской идентификатор товара (хеш-строка).	Текст (32-значный буквенно-цифровой код)',
        distribution_center_id UInt8 COMMENT 'Идентификатор распределительного центра/склада.	1 — 10'
    ) ENGINE = MergeTree ()
order by
    (id) COMMENT 'Сырой слой. Каталог товаров.';

create table
    if not exists raw.ecommerce__order_items (
        id UInt32 comment 'Уникальный идентификатор записи (элемента в заказе). Первичный ключ.	1 — 181759',
        order_id UInt32 comment 'Идентификатор заказа, к которому относится элемент.	1 — 125226',
        user_id UInt32 comment 'Идентификатор пользователя, сделавшего заказ.	1 — 100000',
        product_id UInt32 comment 'Идентификатор купленного товара.	1 — 29120',
        status LowCardinality (String) comment 'Текущий статус обработки элемента заказа. Текст (Complete, Cancelled, Shipped, Processing, Returned)',
        created_at DateTime comment 'Дата и время создания записи / добавления в корзину (UTC).	Null — 2024-01-22 00:00:00',
        shipped_at Nullable (DateTime) comment 'Дата и время отправки товара со склада (может быть пустой).	Null — 2024-01-21 00:00:00',
        delivered_at Nullable (DateTime) comment 'Дата и время доставки товара (может быть пустой).	Null — 2024-01-26 00:00:00',
        returned_at Nullable (DateTime) comment 'Дата и время возврата товара (может быть пустой).	Null — 2024-01-28 00:00:00',
        sale_price Decimal(15, 2) comment 'Фактическая цена продажи товара с учетом скидок.	0.02 — 999.0'
    ) engine = MergeTree ()
partition by
    toYYYYMM (created_at)
order by
    (created_at, id) comment 'Сырой слой. Товары, входящие в состав заказов';

create table
    if not exists raw.ecommerce__distribution_centers (
        id UInt8 comment 'Уникальный идентификатор распределительного центра (склада). Первичный ключ.	1 — 10',
        name LowCardinality (String) comment 'Название распределительного центра и его географическое положение (Город, Штат).	Текст (например, Memphis TN, Chicago IL, Savannah GA)'
    ) engine = MergeTree ()
order by
    id comment 'Сырой слой. Распределительные центры и склады, с которых осуществляется отгрузка товаров';