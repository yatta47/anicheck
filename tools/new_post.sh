#!/bin/sh

DATE=`date +%Y-%m-%d-%H-%M-%S`
FILE_NAME=${DATE}-article.md

touch ${FILE_NAME}

cat << EOF > ${FILE_NAME}
---
layout: post
title: ${DATE} Sample post
tags: [test, ranking]
---
EOF

RANK_ALL_FILE_NAME=rank_all_`date +%Y%m%d`
RANK_NEW_FILE_NAME=rank_new_`date +%Y%m%d`

cat << EOF >> ${FILE_NAME}
{% if site.data.${RANK_NEW_FILE_NAME}.size > 0 %}
<h2>New</h2>
<ul class="demo1">
{% for item in site.data.${RANK_NEW_FILE_NAME} %}
    <li>
        <a href="{{ item.link }}" target="_blank">
            <img src="{{ item.image }}" class="sample1" />
        </a>
        <p>
            {{ item.song }}
        </p>
    </li>
{% endfor %}
</ul>
<br class="clear">
{% else %}
<h2>New</h2>
No Items
<br class="clear">
{% endif %}

<h2>Ranking</h2>
{% if site.data.${RANK_ALL_FILE_NAME}.size > 0 %}
<ul class="demo1">
{% for item in site.data.${RANK_ALL_FILE_NAME} %}
    <li>
        <a href="{{ item.link }}" target="_blank">
            <img src="{{ item.image }}" class="sample1" />
        </a>
        <p>
            {{ item.song }}
        </p>
    </li>
{% endfor %}
</ul>
<br class="clear">
{% else %}
No Items
<br class="clear">
{% endif %}
EOF








OUTPUT_DIR="../_posts"

mv ${FILE_NAME} ${OUTPUT_DIR}/.