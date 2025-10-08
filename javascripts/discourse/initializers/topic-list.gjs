import SortableColumn from "discourse/components/topic-list/header/sortable-column";
import avatar from "discourse/helpers/avatar";
import formatDate from "discourse/helpers/format-date";
import { withPluginApi } from "discourse/lib/plugin-api";

const HeaderLatestPosterCell = <template>
  <SortableColumn
    @sortable={{@sortable}}
    @order="last-post"
    @activeOrder={{@order}}
    @changeSort={{@changeSort}}
    @ascending={{@ascending}}
    @name="user.last_posted"
  />
</template>;

const ItemLatestPosterCell = <template>
  <td class="last-post topic-list-data">
    <div class="last-post__contents">
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
    </div>
  </td>
</template>;

export default {
  name: "discourse-simple-theme-topic-list",

  initialize() {
    withPluginApi((api) => {
      api.registerValueTransformer(
        "topic-list-columns",
        ({ value: columns }) => {
          columns.delete("posters");
          columns.delete("views");
          columns.delete("activity");
          columns.add("latest-poster", {
            header: HeaderLatestPosterCell,
            item: ItemLatestPosterCell,
          });
          return columns;
        }
      );
    });
  },
};
