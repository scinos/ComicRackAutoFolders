<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xsi">

    <!--
       - Main template for the parent folder of the folders & lists structure
       -
       - Edit the XPath so it matchs your folder structure. Please, note that
       - this XPath needs to match the Items node inside the target folder.
       -
       - Example:
       -    Leet's say you want your folders saved on
       -    /Comics/Sorted
       -
       -    Use this value for match
       -    match='//ComicLists/Item[@Name="Comics"]/Items/Item[@Name="Sci-fi"]/Items'
    -->
    <xsl:template match='//ComicLists/Item[@Name="Catalogados"]/Items'>
        <Items>
            <Item xsi:type="ComicListItemFolder" Name="OneShot">
                <NewBookCountDate/>
                <CacheStorage/>
                <Display/>
                <xsl:call-template name="createOneshotsFolder" />
            </Item>
            <Item xsi:type="ComicListItemFolder" Name="Series">
                <NewBookCountDate/>
                <CacheStorage/>
                <Display/>
                <Items>
                    <Item xsi:type="ComicListItemFolder" Name="Limited">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesLimitedFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Complete">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesCompleteFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Ongoing">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesOngoingFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Incomplete">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesIncompleteFolder" />
                    </Item>
                </Items>
            </Item>
            <Item xsi:type="ComicListItemFolder" Name="Arcs">
                <NewBookCountDate/>
                <CacheStorage/>
                <Display/>
                <Items>
                    <Item xsi:type="ComicListItemFolder" Name="Completos">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createArcsCompleteFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Incompletos">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createArcsIncompleteFolder" />
                    </Item>
                </Items>
            </Item>
        </Items>
    </xsl:template>


    <!-- Create the Folder for Oneshots -->
    <xsl:template name='createOneshotsFolder'>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createOneshotsList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Create the Folder for Series/Limited -->
    <xsl:template name='createSeriesLimitedFolder'>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesLimitedList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Create the Folder for Series/Complete -->
    <xsl:template name='createSeriesCompleteFolder'>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesCompleteList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Create the Folder for Series/Ongoing -->
    <xsl:template name='createSeriesOngoingFolder'>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesOngoingList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Create the Folder for Series/Incomplete -->
    <xsl:template name='createSeriesIncompleteFolder'>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesIncompleteList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Create the Folder for Arcs/Complete -->
    <xsl:template name='createArcsCompleteFolder'>
        <Items>
            <xsl:for-each select='//Book/AlternateSeries[not(.=preceding::Book/AlternateSeries)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createArcsCompleteList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Create the Folder for Arcs/Incomplete -->
    <xsl:template name='createArcsIncompleteFolder'>
        <Items>
            <xsl:for-each select='//Book/AlternateSeries[not(.=preceding::Book/AlternateSeries)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createArcsIncompleteList" >
                    <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>


    <!--
       - Create the lists of Oneshots comics. A list per comic series will be created,
       - if the serie:
       -     has more than one comic
       -     and has more or equal comics than the SeriesCount
       -     and SeriesCount is not bigger than 12
    -->
    <xsl:template name="createOneshotsList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="count(//Book[Series=$listName]) = 1 and ../Count=1">
            <xsl:message>- OneShot: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
       - Create the lists of Limited comics. A list per comic series will be created,
       - if the serie:
       -     has more than one comic
       -     and has more or equal comics than the SeriesCount
       -     and SeriesCount is not bigger than 12
    -->
    <xsl:template name="createSeriesLimitedList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="count(//Book[Series=$listName]) > 1 and count(//Book[Series=$listName])>=number(../Count) and 12 >= ../Count">
            <xsl:message>- Limited series: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
       - Create the lists of Incomplete comics. A list per comic series will be created,
       - if the serie:
       -     has fewer comics than SeriesCount
       -     SeriesCount is bigger than one
       -     is not marked as Complete
    -->
    <xsl:template name="createSeriesIncompleteList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="../Count > count(//Book[Series=$listName]) and ../Count>1 and (not(../SeriesComplete) or ../SeriesComplete!='Yes')">
            <xsl:message>- Incomplete: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
       - Create the lists of Ongoing comics. A list per comic series will be created,
       - if the serie:
       -     don't have SeriesCount
       -     is not marked as Complete
    -->
    <xsl:template name="createSeriesOngoingList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="not(../Count) and (not(../SeriesComplete) or ../SeriesComplete!='Yes')">
            <xsl:message>- Ongoing: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
       - Create the lists of Comnplete comics. A list per comic series will be created,
       - if the serie:
       -     and have more or equal comics than the SeriesCount
       -     and SeriesCount is bigger than 12
       - Can be overriden with SeriesComplete
    -->
    <xsl:template name="createSeriesCompleteList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="(count(//Book[Series=$listName]) > 1 and count(//Book[Series=$listName])>=number(../Count) and ../Count > 12) or ../SeriesComplete='Yes'">
            <xsl:message>- Complete: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
       - Create the lists of Comnplete comics. A list per comic series will be created,
       - if the serie:
       -     and have more or equal comics than the AlternateCount
    -->
    <xsl:template name="createArcsCompleteList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="count(//Book[AlternateSeries=$listName])>=number(../AlternateCount)">
            <xsl:message>- Arc complete: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                <xsl:with-param name="matcher">ComicBookAlternateSeriesMatcher</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
       - Create the lists of Comnplete comics. A list per comic series will be created,
       - if the serie:
       -     and have more or equal comics than the AlternateCount
    -->
    <xsl:template name="createArcsIncompleteList">
        <xsl:param name="listName">-</xsl:param>

        <xsl:if test="number(../AlternateCount)>count(//Book[AlternateSeries=$listName]) or not(../AlternateCount)">
            <xsl:message>- Arc Incomplete: <xsl:value-of select="."/></xsl:message>
            <xsl:call-template name="createDynamicList_IS">
                <xsl:with-param name="listName"><xsl:value-of select="."/></xsl:with-param>
                <xsl:with-param name="matcher">ComicBookAlternateSeriesMatcher</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Creates a DynamicList using the matcher IS. The name of the list will be the currentNode -->
    <xsl:template name="createDynamicList_IS">
        <xsl:param name="listName">-</xsl:param>
        <xsl:param name="matcher">ComicBookSeriesMatcher</xsl:param>

        <xsl:choose>

            <!-- Try to reuse old list, if present -->
            <xsl:when test='//Items/Item[@Name=$listName]//ComicBookMatcher[@*=$matcher]'>
                <xsl:message>   [OLD] <xsl:value-of select="$listName"/></xsl:message>
                <!--TODO Investigate how to do this using '.' instead $listName-->
                 <xsl:copy-of select='(//Items/Item[@Name=$listName])[1]'/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:message>   [NEW] <xsl:value-of select="$listName"/></xsl:message>
                <Item xsi:type="ComicSmartListItem" Name="{$listName}">
                    <NewBookCountDate/>
                    <CacheStorage/>
                    <Display/>
                    <Matchers>
                        <ComicBookMatcher xsi:type="{$matcher}">
                            <MatchValue><xsl:value-of select="$listName"/></MatchValue>
                        </ComicBookMatcher>
                    </Matchers>
                </Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- This is an identity template - it copies everything that doesn't match another template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:output method="xml"/>

</xsl:stylesheet>