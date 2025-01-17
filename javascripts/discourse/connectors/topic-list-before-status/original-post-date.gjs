import Component from "@glimmer/component";
import { service } from "@ember/service";
import formatDate from "discourse/helpers/format-date";

export default class OriginalPostDate extends Component {
  @service site;

  <template>
    {{~#if this.site.desktopView~}}
      {{~#if @outletArgs.topic.creator~}}
        <span class="op-data">
          {{~! no whitespace ~}}
          <a
            href="/u/{{@outletArgs.topic.creator.username}}"
            data-auto-route="true"
            data-user-card={{@outletArgs.topic.creator.username}}
          >{{@outletArgs.topic.creator.username}}</a>
          <a class="op-date" href={{@outletArgs.topic.url}}>
            {{formatDate @outletArgs.topic.createdAt format="tiny"}}
          </a>
          {{~! no whitespace ~}}
        </span>
      {{~/if~}}
    {{~/if~}}
  </template>
}
