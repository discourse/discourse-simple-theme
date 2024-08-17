import { hash } from "@ember/helper";
import { on } from "@ember/modifier";
import PluginOutlet from "discourse/components/plugin-outlet";
import ActionList from "discourse/components/topic-list/action-list";
import TopicExcerpt from "discourse/components/topic-list/topic-excerpt";
import TopicLink from "discourse/components/topic-list/topic-link";
import TopicListHeaderColumn from "discourse/components/topic-list/topic-list-header-column";
import UnreadIndicator from "discourse/components/topic-list/unread-indicator";
import TopicPostBadges from "discourse/components/topic-post-badges";
import TopicStatus from "discourse/components/topic-status";
import avatar from "discourse/helpers/avatar";
import categoryLink from "discourse/helpers/category-link";
import discourseTags from "discourse/helpers/discourse-tags";
import formatDate from "discourse/helpers/format-date";
import { withPluginApi } from "discourse/lib/plugin-api";
import i18n from "discourse-common/helpers/i18n";

const ActivityHeader = <template>
  <TopicListHeaderColumn
    @sortable={{@sortable}}
    @order="activity"
    @activeOrder={{@order}}
    @changeSort={{@changeSort}}
    @ascending={{@ascending}}
    @forceName={{i18n (themePrefix "last_post")}}
  />
</template>;

const TopicColumn = <template>
  <td class="main-link clearfix topic-list-data" colspan="1">
    <PluginOutlet
      @name="topic-list-before-link"
      @outletArgs={{hash topic=@topic}}
    />

    {{~! no whitespace ~}}
    <PluginOutlet
      @name="topic-list-before-status"
      @outletArgs={{hash topic=@topic}}
    />
    {{~! no whitespace ~}}
    <TopicStatus @topic={{@topic}} />
    {{~! no whitespace ~}}
    <TopicLink
      {{on "focus" this.onTitleFocus}}
      {{on "blur" this.onTitleBlur}}
      @topic={{@topic}}
      class="raw-link raw-topic-link"
    />
    {{~! no whitespace ~}}
    <PluginOutlet
      @name="topic-list-after-title"
      @outletArgs={{hash topic=@topic}}
    />
    {{~! no whitespace ~}}
    <UnreadIndicator
      @includeUnreadIndicator={{this.includeUnreadIndicator}}
      @topicId={{@topic.id}}
      class={{this.unreadClass}}
    />
    {{~#if @showTopicPostBadges~}}
      <TopicPostBadges
        @unreadPosts={{@topic.unread_posts}}
        @unseen={{@topic.unseen}}
        @newDotText={{this.newDotText}}
        @url={{@topic.lastUnreadUrl}}
      />
    {{~/if}}

    {{discourseTags @topic mode="list" tagsForUser=@tagsForUser}}

    {{#if this.expandPinned}}
      <TopicExcerpt @topic={{@topic}} />
    {{/if}}

    <div class="creator">
      {{#unless @hideCategory}}
        {{#unless @topic.isPinnedUncategorized}}
          <PluginOutlet
            @name="topic-list-before-category"
            @outletArgs={{hash topic=@topic}}
          />
          {{categoryLink @topic.category}}
        {{/unless}}
      {{/unless}}

      {{~#if @topic.creator~}}
        <a
          href="/u/{{@topic.creator.username}}"
          data-auto-route="true"
          data-user-card={{@topic.creator.username}}
        >{{@topic.creator.username}}</a>
        <a href={{@topic.url}}>{{formatDate @topic.createdAt format="tiny"}}</a>
      {{~/if~}}

      <ActionList
        @topic={{@topic}}
        @postNumbers={{@topic.liked_post_numbers}}
        @icon="heart"
        class="likes"
      />
    </div>
  </td>
  <PluginOutlet
    @name="topic-list-main-link-bottom"
    @outletArgs={{hash topic=@topic}}
  />
</template>;

const ActivityColumn = <template>
  <td class="last-post topic-list-data">
    <div class="poster-avatar">
      <a
        href={{@topic.lastPostUrl}}
        data-user-card={{@topic.last_poster_username}}
      >{{avatar @topic.lastPosterUser imageSize="medium"}}</a>
    </div>
    <div class="poster-info">
      <a href={{@topic.lastPostUrl}}>
        {{formatDate @topic.bumpedAt format="tiny"}}
      </a>
      <span class="editor">
        <a
          href="/u/{{@topic.last_poster_username}}"
          data-auto-route="true"
          data-user-card={{@topic.last_poster_username}}
        >{{@topic.last_poster_username}}</a>
      </span>
    </div>
  </td>
</template>;

export default {
  name: "discourse-simple-theme-topic-list",

  initialize() {
    withPluginApi("1.35.0", (api) => {
      api.topicListHeaderColumns.delete("posters");
      api.topicListHeaderColumns.delete("views");
      api.topicListHeaderColumns.reposition("replies", { before: "activity" });
      api.topicListHeaderColumns.replace("activity", ActivityHeader);

      api.topicListItemColumns.replace("topic", TopicColumn);
      api.topicListItemColumns.delete("posters");
      api.topicListItemColumns.delete("views");
      api.topicListItemColumns.reposition("replies", { before: "activity" });
      api.topicListItemColumns.replace("activity", ActivityColumn);
    });
  },
};
