require 'spec_helper'

TAG_SET_1 = ['ника', 'свобода для проклятых', 'старьевщик', 'властитель мертвых', 'знаки', 'плохой', 'инициация', 'дергач', 'новая работа', 'все остальное до фонаря', 'ящик', 'зима на восточном склоне', 'плацкарт', 'увлечение', 'в утробе 2', 'плохой час', 'пунктирный', 'чик чиу', 'пакетик с вишней', 'за дверью чужак', 'украденный город', 'сад грехов', 'высшая справедливость', 'бойня', 'город светлячков', 'башня одиночества', 'черная кровь', 'макрель', 'визит в елань', 'морой', 'совет дружины', 'америка', 'озеро листьев', 'почитай мне сказку', 'девятая модель голоса из ниоткуда', 'за солью', 'тамбовская волчица', 'ворона и ее психи', 'еда', 'снежки', 'турбаза черный лог', 'deux ex mmachina', 'могильник'].freeze

TAG_SET_2 = ['сядьте поудобнее расслабьтесь', 'совет дружины', 'морой', 'плацкарт', 'визит в елань', 'весы', 'до добра нас это не доведет', 'только маме не говорим'].freeze

describe 'Horrorparser' do
  it 'test' do
    expect(true).to be(true)
  end
end

describe HorrorParser::Service do
  it 'persist_pages return true on empty list' do
    expect(HorrorParser::Service.persist_pages([])).to be(true)
  end

  it 'persist_pages return true for list of elemets' do
    pages = []
    File.open('spec/fixtures/1.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/1', body: file.read }
    end
    File.open('spec/fixtures/2.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/2', body: file.read }
    end
    expect(HorrorParser::Service.persist_pages(pages)).to be(true)
  end

  it 'persist_pages persists pages to db for list of elements' do
    pages = []
    File.open('spec/fixtures/1.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/1', body: file.read }
    end
    File.open('spec/fixtures/2.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/2', body: file.read }
    end
    HorrorParser::Service.persist_pages(pages)
    expect(Page.count).to eq(2)
  end

  it 'persist_page persists with tags from TAG_SET_1' do
    pages = []
    File.open('spec/fixtures/1.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/1', body: file.read }
    end
    HorrorParser::Service.persist_pages(pages)
    expect(Page.last.tags).to match(TAG_SET_1)
  end

  it 'persist_page persists with tags from TAG_SET_2' do
    pages = []
    File.open('spec/fixtures/2.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/1', body: file.read }
    end
    HorrorParser::Service.persist_pages(pages)
    expect(Page.last.tags).to match(TAG_SET_2)
  end

  it 'persist_page persists with tags from TAG_SET_2' do
    pages = []
    File.open('spec/fixtures/2.html', 'r') do |file|
      pages << { url: 'http://horrorbook.ru/page/1', body: file.read }
    end
    HorrorParser::Service.persist_pages(pages)
    expect(Page.last.url).to eq('http://horrorbook.ru/page/1')
  end

  describe '.normalize' do
    it 'cleans text' do
      expect(HorrorParser::Service.normalize('«Сядьте поудобнее. Расслабьтесь» - НЕТ'))
        .to eq('сядьте поудобнее расслабьтесь')
      expect(HorrorParser::Service.normalize('«Сядьте поудобнее. Расслабьтесь» - ДА'))
        .to eq('сядьте поудобнее расслабьтесь')
      expect(HorrorParser::Service.normalize('В УТРОБЕ (2)'))
        .to eq('в утробе 2')
      expect(HorrorParser::Service.normalize('DEUS EX MMACHINA'))
        .to eq('deus ex mmachina')
      expect(HorrorParser::Service.normalize('ГОВОРИ ДА ВСЕГДА'))
        .to eq('говори да всегда')
    end
  end
end
