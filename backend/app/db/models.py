from typing import Annotated
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import String, Float, Integer
from sqlalchemy.dialects.postgresql import JSONB

# Custom type for primary keys
intpk = Annotated[int, mapped_column(Integer, primary_key=True)]

class Base(DeclarativeBase):
    pass

class Keyword(Base):
    __tablename__ = "keywords"
    
    id: Mapped[intpk]
    ngram: Mapped[str] = mapped_column(String(100), unique=True, index=True)
    threat_bucket: Mapped[str] = mapped_column(String(50))
    weight: Mapped[float] = mapped_column(Float)

class ReportedNumber(Base):
    __tablename__ = "reported_numbers"
    
    id: Mapped[intpk]
    phone_number: Mapped[str] = mapped_column(String(20), unique=True, index=True)
    report_count: Mapped[int] = mapped_column(Integer, default=1)
    # JSONB is highly efficient in Postgres for storing lists of categories/flags
    categories: Mapped[list[str]] = mapped_column(JSONB, default=list)