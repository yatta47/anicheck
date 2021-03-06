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
{% for item in site.data.${RANK_NEW_FILE_NAME} %}
<div class="media">
    <div class="media__rank">
    {{ item.rank }}
    </div>
    <div class="media__image">
        <img class="sample1" src="{{ item.image }}" alt="">
    </div>
    <div class="media__summary">
        <h2 class="media__heading">{{ item.song }}</h2>
        <p class="media__text">
        {{ item.artist }}
        <ul class="nav1">
            <li><a href="https://www.google.co.jp/search?q={{ item.song }}" target="_blank">Googleで検索</a></li><li><a href="https://www.youtube.com/results?search_query={{ item.song }}&aq=f" target="_blank">Youtubeで検索</a></li><li><a href="https://www.amazon.co.jp/gp/search/?__mk_ja_JP=%83J%83%5E%83J%83i&url=search-alias%3Daps&field-keywords={{ item.song }}" target="_blank">Amazonで検索</a></li>
        </ul>
      </p>
    </div>
</div>
<hr>
{% endfor %}
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
    <li class="{{ item.css }}-border">
        <a href="{{ item.link }}" target="_blank">
            <img src="{{ item.image }}" class="sample1" />
        </a>
        <p class="{{ item.css }}-textarea">
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