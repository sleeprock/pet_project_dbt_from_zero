INSERT INTO
    raw.ecommerce__users (
        id,
        first_name,
        last_name,
        email,
        age,
        gender,
        state,
        street_address,
        postal_code,
        city,
        country,
        traffic_source,
        created_at
    )
SELECT
    id,
    first_name,
    last_name,
    email,
    age,
    gender,
    state,
    street_address,
    postal_code,
    city,
    country,
    traffic_source,
    -- Защищаем пайплайн: если парсинг упадет, вернется Null, а не упадет вся модель
    parseDateTimeBestEffort (created_at) AS created_at
FROM
    url (
        'https://huggingface.co/datasets/maksimsad/ecommerce_dbt_course/resolve/main/users.csv', -- Путь
        'CSVWithNames' -- Тип загружаемого файла
    ) SETTINGS max_http_get_redirects = 20 -- Максимальное кол-во редиректов, нужно для доступа к файлам
;

INSERT INTO
    raw.ecommerce__orders (
        order_id,
        user_id,
        status,
        created_at,
        returned_at,
        shipped_at,
        delivered_at,
        num_of_item
    )
SELECT
    order_id,
    user_id,
    status,
    parseDateTimeBestEffort (created_at) AS created_at,
    parseDateTimeBestEffortOrNull (returned_at) AS returned_at,
    parseDateTimeBestEffortOrNull (shipped_at) AS shipped_at,
    parseDateTimeBestEffortOrNull (delivered_at) AS delivered_at,
    num_of_item
FROM
    url (
        'https://huggingface.co/datasets/maksimsad/ecommerce_dbt_course/raw/main/orders.csv',
        'CSVWithNames'
    ) SETTINGS max_http_get_redirects = 20;

insert into
    raw.ecommerce__distribution_centers (id, name)
select
    id,
    name
FROM
    url (
        'https://huggingface.co/datasets/maksimsad/ecommerce_dbt_course/raw/main/distribution_centers.csv',
        'CSVWithNames'
    ) SETTINGS max_http_get_redirects = 20;

insert into
    raw.ecommerce__products (
        id,
        cost,
        category,
        name,
        brand,
        retail_price,
        department,
        sku,
        distribution_center_id
    )
select
    id,
    cost,
    category,
    name,
    brand,
    retail_price,
    department,
    sku,
    distribution_center_id
from
    url (
        'https://huggingface.co/datasets/maksimsad/ecommerce_dbt_course/raw/main/products.csv',
        'CSVWithNames'
    ) SETTINGS max_http_get_redirects = 20;

insert into
    raw.ecommerce__order_items (
        id,
        order_id,
        user_id,
        product_id,
        status,
        created_at,
        shipped_at,
        delivered_at,
        returned_at,
        sale_price
    )
select
    id,
    order_id,
    user_id,
    product_id,
    status,
    parseDateTimeBestEffort (created_at),
    parseDateTimeBestEffortOrNull (shipped_at),
    parseDateTimeBestEffortOrNull (delivered_at),
    parseDateTimeBestEffortOrNull (returned_at),
    sale_price
from
    url (
        'https://huggingface.co/datasets/maksimsad/ecommerce_dbt_course/resolve/main/order_items.csv',
        'CSVWithNames'
    ) SETTINGS max_http_get_redirects = 20;