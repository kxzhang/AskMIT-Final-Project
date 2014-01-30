class Question < ActiveRecord::Base
  # Accessible Attributes
  attr_accessible :details, :title, :score, :user_id, :created_at, :is_anon

  # Associations
  belongs_to :user
  has_and_belongs_to_many :hashtags
  has_many :answers, :dependent => :destroy
  has_many :votes, :dependent => :destroy

  # Validations
  validates :title, :presence => true
  # Model Methods

  # make it searchable
  # Note that ActiveRecord ARel from() doesn't appear to accommodate "?"
  # param placeholder, hence the need for manual parameter sanitization
  def self.tsearch_query(search_terms, limit = query_limit)
    words = sanitize(search_terms.scan(/\w+/) * "|")

    Question.from("questions, to_tsquery('pg_catalog.english', #{words}) as q").
        where("tsv @@ q").order("ts_rank_cd(tsv, q) DESC").limit(limit)
  end

  # Selects search results with plain text title & details columns.
  # Select columns are explicitly listed to avoid returning the long redundant tsv strings
  def self.plain_tsearch(search_terms, limit = query_limit)
    tsearch_query(search_terms, limit)
  end

  # Select search results with HTML highlighted title & details columns
  def self.highlight_tsearch(search_terms, limit = query_limit)
    details = "ts_headline(details, q, 'StartSel=<em>, StopSel=</em>, HighlightAll=TRUE') as details"
    title = "ts_headline(title, q, 'StartSel=<em>, StopSel=</em>, HighlightAll=TRUE') as title"
    tsearch_query(search_terms, limit)
  end

  def self.query_limit; 25; end

  def updateScore(score_change)
    new_score = self.score + score_change
    self.update_attributes(:score => new_score)
  end

end

