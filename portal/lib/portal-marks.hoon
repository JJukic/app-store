/-  *portal-data
/+  portal, docket
|%
++  enjs
  =,  enjs:format
  |%
  ++  enjs-all-items
    |=  =all-items
    ^-  json
    =/  lis  ~(tap by all-items)
    [%a (turn lis enjs-pointer-and-item)]
  ++  enjs-pointer-and-item
    |=  [=pointer =item]
    ^-  json
    |^
    %-  pairs
    :~  ['key' (enjs-jam-pointer pointer)]
        ['data' (enjs-data data.item)]
        ['meta-data' (enjs-meta-data meta-data.item)]
        ['social' (enjs-social social.item)]
        ['item-sig' (enjs-sig item-sig.item)]
    ==
    ++  enjs-meta-data
      |=  [=meta-data]
      ^-  json
      %-  pairs
      :~  ['id' (enjs-id id.meta-data)]
          ['updated-at' s+updated-at.meta-data]
          ['permissions N/A' s+'']
          ['reach N/A' s+'']
          ['outside-sigs N/A' s+'']
      ==
    ++  enjs-data
      |=  [=data]
      ^-  json
      |^
      %-  pairs
      :~  ['general' (enjs-general general.data)]
          ['bespoke' (enjs-bespoke bespoke.data)]
      ==
      ++  enjs-general
        |=  [=general]
        ^-  json
        %-  pairs
        :~  ['title' s+title.general]
            ['link' s+link.general]
            ['description' s+description.general]
            ['tags' (enjs-cord-list tags.general)]
            ['properties N/A' s+'']
            ['pictures' (enjs-cord-list pictures.general)]
            ['image' s+image.general]
            ['color' s+color.general]
        ==
      ++  enjs-bespoke
        |=  [=bespoke]
        ^-  json
        |^
        %-  pairs
        :~  :-  -.bespoke
            ?-    -.bespoke
                %app
              %-  pairs
              :~  ['dist-desk' s+dist-desk.bespoke]
                  ['signature' (enjs-sig sig.bespoke)]
                  ['desk-hash' s+`@t`(scot %uv desk-hash.bespoke)]
                  ['docket' (docket:enjs:docket docket.bespoke)]
              ==
                %curator-page
              %-  pairs
              :~  ['curator-page' (enjs-recommendations recommendations.bespoke)]
              ==
                %validity-store
              %-  pairs
              :~  ['validity-store N/A' s+'']
              ==
                %list
              %-  pairs
              :~  ['list' (enjs-recommendations recommendations.bespoke)]
              ==
                %other
              %-  pairs
              :~  ['other' s+'']
              ==
            ==
        ==
        ++  enjs-recommendations
          |=  =recommendations
          ^-  json
          %-  pairs
          :~  ['type' s+`@t`-.recommendations]
              ['pointer-list' (enjs-jammed-pointer-list pointer-list.recommendations)]
          ==
        --
      --
    ++  enjs-social
      |=  =social
      ^-  json
      |^
      %-  pairs
      :~  ['ratings' (enjs-rats ratings.social.item)]
          ['comments' (enjs-coms comments.social.item)]
          ['reviews' (enjs-revs reviews.social.item)]
      ==
      ++  enjs-rats
        |=  =ratings
        ^-  json
        |^
        =/  lis  ~(tap by ratings)
        [%a (turn lis enjs-rat)]
        ++  enjs-rat
          |=  [usr-name=@p rating=[rating-num=@ud =updated-at =created-at]]
          ^-  json
          %-  pairs
          :~  ['key' s+`@t`(scot %p usr-name)]
              ['ship' s+`@t`(scot %p usr-name)]
              ['rating-num' (numb rating-num.rating)]
              ['updated-at' s+updated-at.rating]
              ['created-at' s+created-at.rating]
          ==
        --
      ++  enjs-coms
        |=  =comments
        ^-  json
        |^
        =/  lis  ~(tap by comments)
        [%a (turn `(list [com-key comment])`lis enjs-com)]
        ++  enjs-com
          |=  [=com-key =comment]
          ^-  json
          %-  pairs
          :~  ['key' (enjs-jam-com-key com-key)]
              ['ship' s+`@t`(scot %p ship.com-key)]
              ['text' s+text.comment]
              ['updated-at' s+updated-at.comment]
              ['created-at' s+created-at.com-key]
          ==
        ++  enjs-jam-com-key
          |=  =com-key
          ^-  json
          %-  wall
          ~[(scow %p ship.com-key) (trip created-at.com-key)]
        --
      ++  enjs-revs
        |=  =reviews
        ^-  json
        |^
        =/  lis  ~(tap by reviews)
        [%a (turn lis enjs-rev)]
        ++  enjs-rev
          |=  [reviewer=@p =review]
          ^-  json
          %-  pairs
          :~  ['key' s+`@t`(scot %p reviewer)]
              ['ship' s+`@t`(scot %p reviewer)]
              ['text' s+text.review]
              ['hash' s+`@t`(scot %uv hash.review)]
              ['is-current' b+is-current.review]
              ['is-safe' b+is-safe.review]
              ['updated-at' s+updated-at.review]
              ['created-at' s+created-at.review]
          ==
        --
      --
    --
  ++  enjs-jammed-pointer-list
    |=  =pointer-list
    ^-  json
    :-  %a
    %+  turn  pointer-list
    |=(=pointer (enjs-jam-pointer pointer))
  ++  enjs-pointer-list
    |=  =pointer-list
    ^-  json
    :-  %a
    %+  turn  pointer-list
    |=(=pointer (enjs-pointer pointer))
  ++  enjs-sig
    |=  =signature
    ^-  json
    %-  pairs
    :~  ['hex' s+`@t`(scot %ux hex.signature)]
        ['ship' s+`@t`(scot %p ship.signature)]
        ['life' n+(scot %ud life.signature)]
    ==
  ++  enjs-cord-list
    |=  cords=(list @t)
    ^-  json
    :-  %a
    %+  turn  cords
    |=(cor=@t s+cor)
  ++  enjs-jam-pointer
    |=  =pointer
    ^-  json
    %-  wall
    ~[?~(points-to-item.pointer "0" "1") (scow %p p.id.pointer) (trip q.id.pointer) (trip r.id.pointer)]
  ++  enjs-pointer
    |=  =pointer
    ^-  json
    %-  pairs
    :~  ['points-to-item' b+points-to-item.pointer]
        ['id' (enjs-id id.pointer)]
    ==
  ++  enjs-id
    |=  =id
    ^-  json
    %-  pairs
    :~  ['ship' s+`@t`(scot %p p.id)]
        ['time' s+q.id]
        ['type' s+`@t`r.id]
    ==
    ::

  :: ++  enjs-app-set
  ::   |=  =app-set
  ::   ^-  json
  ::   =/  app-list  ~(tap in app-set)
  ::   [%a (turn app-list |=(app=@tas s+`@t`app))]
  :: ++  enjs-aux-map
  ::   |=  =aux-map
  ::   ^-  json
  ::   =/  lis  ~(tap by aux-map)
  ::   =/  modify
  ::     |=  [=dev-name =app-set]
  ::     [`@t`(scot %p dev-name) (enjs-app-set app-set)]
  ::   (pairs (turn lis modify))
  :: ++  enjs-cat-set
  ::   |=  =cat-set
  ::   ^-  json
  ::   =/  cat-list  ~(tap in cat-set)
  ::   [%a (turn cat-list |=(=category s+`@t`category))]
  --
::
::
:: ++  dejs
::   =,  dejs:format
::   |%
::   ++  dejs-dev-action
::     |=  jon=json
::     ^-  dev-action
::     |^
::     %.  jon
::     %-  of
::     :~  [%add (ot ~[app-name+so dev-input+dev-input])]
::         [%edit (ot ~[app-name+so dev-input+dev-input])]
::         [%del (ot ~[app-name+so])]
::     ==
::     ++  dev-input
::       |=  jon=json
::       ^-  ^dev-input
::       %.  jon
::       %-  ot
::       :~  description+so
::           keywords+(ar so)
::           screenshots+(ar so)
::           dst-desk+so
::       ==
::     --
::   ++  dejs-cur-action
::     |=  jon=json
::     ^-  cur-action
::     %.  jon
::     %-  of
::     :~  [%sub (ot ~[dev-name+dejs-ship])]
::         [%unsub (ot ~[dev-name+dejs-ship])]
::         [%cur-info (ot ~[cur-info+dejs-cur-info])]
::         [%select (ot ~[key-list+dejs-key-list cat-map+dejs-cat-map])]
::         [%cats (ot ~[cat-set+dejs-cat-set])]
::     ==
::   ++  dejs-usr-action
::     |=  jon=json
::     ^-  usr-action
::     %.  jon
::     %-  of
::     :~  [%sub (ot ~[cur-name+dejs-ship])]
::         [%unsub (ot ~[cur-name+dejs-ship])]
::     ==
::   ++  dejs-visit-dev-action
::     |=  jon=json
::     ^-  visit-dev-action
::     %.  jon
::     %-  of
::     :~  [%rate (ot ~[key+dejs-key rating-num+ni])]
::         [%unrate (ot ~[key+dejs-key])]
::         [%add-com (ot ~[key+dejs-key text+so])]
::         [%edit-com (ot ~[key+dejs-key created-at-str+so text+so])]
::         [%del-com (ot ~[key+dejs-key created-at-str+so])]
::         [%put-rev (ot ~[key+dejs-key text+so hash+dejs-hash is-safe+bo])]
::         [%del-rev (ot ~[key+dejs-key])]
::     ==
::   ::
::   ::  helper dejs arms
::   ++  dejs-cur-info
::     |=  jon=json
::     ^-  cur-info
::     %.  jon
::     %-  ot
::     :~  cur-title+so
::         cur-image+so
::         cur-intro+so
::     ==
::   ++  dejs-key-list
::     |=  jon=json
::     ^-  key-list
::     %.  jon
::     (ar dejs-key)
::   ++  dejs-cat-map
::     |=  jon=json
::     ^-  cat-map
::     |^
::     (malt ((ar dejs-key-cat) jon))
::     ++  dejs-key-cat
::       |=  jon=json
::       ^-  [=key =category]
::       %.  jon
::       %-  ot
::       :~  key+dejs-key
::           category+so
::       ==
::     --
::   ++  dejs-cat-set
::     |=  jon=json
::     ^-  cat-set
::     %-  silt
::     %.  jon
::     (ar so)
::   ::
::   ::  helper dejs arms
::   ++  dejs-key
::     |=  jon=json
::     ^-  key
::     %.  jon
::     %-  ot
::     :~  dev-name+dejs-ship
::         app-name+so
::     ==
::   ++  dejs-ship
::     |=  jon=json
::     ^-  @p
::     ((se %p) jon)
::   ++  dejs-hash
::     |=  jon=json
::     ^-  @uv
::     `@uv`(slav %uv (so jon))
::   --
--
