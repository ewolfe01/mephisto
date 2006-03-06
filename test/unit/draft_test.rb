require File.dirname(__FILE__) + '/../test_helper'

class DraftTest < Test::Unit::TestCase
  fixtures :contents, :users, :content_drafts
  set_fixture_class :content_drafts => Article::Draft

  def test_should_set_correct_defaults
    assert_equal 'Draft',          Article.draft_class_name
    assert_equal 'content_drafts', Article.draft_table_name
  end

  def test_should_retrieve_current_draft
    assert_equal content_drafts(:welcome), contents(:welcome).draft
  end

  def test_should_find_new_drafts
    assert_equal [content_drafts(:first)], Article::Draft.find_new
    Article.new(:title => 'foo').save_draft
    assert_equal 2, Article::Draft.find_new.length
  end

  def test_should_save_draft_of_new_article
    assert_no_difference Article, :count do
      assert_difference Article::Draft, :count do
        article = Article.new(:title => 'foo')
        article.save_draft
        assert_equal 'foo', article.draft.title
      end
    end
  end
end
